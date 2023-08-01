import os
from io import BytesIO
from pathlib import Path
import pandas as pd
from prefect import flow, task
from prefect_gcp.cloud_storage import GcsBucket
from prefect_gcp import GcpCredentials

@task(log_prints=True)
def extract_from_gcs(path: str) -> pd.DataFrame:
    """Download trip data from GCS"""
    print(f"GCS: {path}")
    gcs_path = f"{path}"
    gcs_block = GcsBucket.load("gcs-decap")
    gcs_block.get_directory(from_path=gcs_path, local_path=f"")

    gcs_path = Path(f"{gcs_path}")

    df = pd.read_parquet(gcs_path)
    print(f"rows: {len(df)}\ncolumns:\n{df.dtypes}\n{df.head(2)}")
    return df

@task(log_prints=True)
def extract_from_local(path: str) -> pd.DataFrame:
    print(f"local: {path}")
    df = pd.read_parquet(path)
    print(f"rows: {len(df)}\ncolumns:\n{df.dtypes}\n{df.head(2)}")
    return df

@task(log_prints=True)
def write_bq(df: pd.DataFrame, year: int, file: str) -> None:
    """Write DataFrame to BiqQuery"""
    gcp_credentials_block = GcpCredentials.load("gcp-decap")
    table_name=file.replace('data/ridb/parquet/','').replace('','').replace('.parquet','')
    print(f"\ndataset: {table_name}")

    if year==0:
        table_name=f"de-capstone.gcs_raw.{table_name}"
    else:
        table_name="de-capstone.gcs_raw.Reservations"
    
    df.to_gbq(
        destination_table=table_name,
        project_id="de-capstone",
        credentials=gcp_credentials_block.get_credentials_from_service_account(),
        chunksize=500_000,
        if_exists="append"
    )


@flow(log_prints=True)
def etl_gcs_to_bq(year: int, path: str) -> None:
    """Main ETL flow to load data into Big Query"""

    # Check whether the specified path exists or not
    if os.path.exists(f"{path}") == True:
        df = extract_from_local(path)
    else:
        df = extract_from_gcs(path)

    write_bq(df, year, path)


@flow()
def etl_parent_flow(year: int, path: str):
    etl_gcs_to_bq(year, path)

if __name__ == "__main__":
    # set local file path
    local_path = "data/ridb/parquet"

    ridbfiles = []
    ridbfiles.append(f"{local_path}/Activities.parquet"),
    ridbfiles.append(f"{local_path}/CampsiteAttributes.parquet"),
    ridbfiles.append(f"{local_path}/Campsites.parquet"),
    ridbfiles.append(f"{local_path}/EntityActivities.parquet"),
    ridbfiles.append(f"{local_path}/Events.parquet"),
    ridbfiles.append(f"{local_path}/Facilities.parquet"),
    ridbfiles.append(f"{local_path}/FacilityAddresses.parquet"),
    ridbfiles.append(f"{local_path}/Links.parquet"),
    ridbfiles.append(f"{local_path}/Media.parquet"),
    ridbfiles.append(f"{local_path}/MemberTours.parquet"),
    ridbfiles.append(f"{local_path}/OrgEntities.parquet"),
    ridbfiles.append(f"{local_path}/Organizations.parquet"),
    ridbfiles.append(f"{local_path}/PermitEntranceAttributes.parquet"),
    ridbfiles.append(f"{local_path}/PermitEntranceZones.parquet"),
    ridbfiles.append(f"{local_path}/PermitEntrances.parquet"),
    ridbfiles.append(f"{local_path}/PermittedEquipment.parquet"),
    ridbfiles.append(f"{local_path}/RecAreaAddresses.parquet"),
    ridbfiles.append(f"{local_path}/RecAreaFacilities.parquet"),
    ridbfiles.append(f"{local_path}/RecAreas.parquet"),
    ridbfiles.append(f"{local_path}/TourAttributes.parquet"),
    ridbfiles.append(f"{local_path}/Tours.parquet")

    for path in ridbfiles:
        etl_parent_flow(0, path)

    for year in range(4):
        etl_parent_flow(year+2019, f"{local_path}/{year+2019}.parquet")

