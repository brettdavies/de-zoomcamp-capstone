import os
from io import BytesIO
from pathlib import Path
import zipfile 
from wget import download
import tarfile
import pandas as pd
from prefect import flow, task
from prefect_gcp.cloud_storage import GcsBucket

@task(log_prints=True)
def fetch(url: str, year: int, file_name: str) -> pd.DataFrame:
    """Read data from web into pandas DataFrame"""
    if year > 0:
        df = pd.read_csv(url).astype({
            "historicalreservationid": "string",
            "ordernumber": "string",
            "agency": "string",
            "orgid": "string",
            "codehierarchy": "string",
            "regioncode": "string",
            "regiondescription": "string",
            "parentlocationid": "string",
            "parentlocation": "string",
            "legacyfacilityid": "string",
            "park": "string",
            "sitetype": "string",
            "usetype": "string",
            "productid": "string",
            "inventorytype": "string",
            "facilityid": "string",
            "facilityzip": "string",
            "facilitystate": "string",
            "facilitylongitude": "float64",
            "facilitylatitude": "float64",
            "customerzip": "string",
            "tax": "float64",
            "usefee": "float64",
            "tranfee": "float64",
            "attrfee": "float64",
            "totalbeforetax": "float64",
            "discount": "float64",
            "totalpaid": "float64",
            "startdate": "string",
            "enddate": "string",
            "orderdate": "string",
            "nights": "string",
            "numberofpeople": "string",
            "equipmentdescription": "string",
            "equipmentlength": "string"
        })
    elif file_name=="CampsiteAttributes_API_v1.csv":
        df = pd.read_csv(url).astype({
            "AttributeID": "int64",
            "AttributeName": "string",
            "AttributeValue": "string",
            "EntityID": "string",
            "EntityType": "string"
        })
    elif file_name=="Media_API_v1.csv":
        df = pd.read_csv(url).astype({
            "MediaID": "string",
            "MediaType": "string",
            "EntityID": "string",
            "EntityType": "string",
            "Title": "string",
            "Subtitle": "string",
            "Description": "string",
            "EmbedCode": "string",
            "Height": "int64",
            "Width": "int64",
            "URL": "string",
            "Credits": "string",
            "IsPrimary": "bool",
            "IsPreview": "bool",
            "IsGallery": "bool"
        })
    elif file_name=="Facilities_API_v1.csv":
        df = pd.read_csv(url).astype({
            "FacilityID": "string",
            "LegacyFacilityID": "string",
            "OrgFacilityID": "int64",
            "ParentOrgID": "string",
            "ParentRecAreaID": "string",
            "FacilityName": "string",
            "FacilityDescription": "string",
            "FacilityTypeDescription": "string",
            "FacilityUseFeeDescription": "string",
            "FacilityDirections": "string",
            "FacilityPhone": "string",
            "FacilityEmail": "string",
            "FacilityReservationURL": "string",
            "FacilityMapURL": "string",
            "FacilityAdaAccess": "string",
            "FacilityLongitude": "float64",
            "FacilityLatitude": "float64",
            "Keywords": "string",
            "StayLimit": "string",
            "Reservable": "bool",
            "Enabled": "bool",
            "LastUpdatedDate": "datetime64[ns]"
        })
    elif file_name=="Campsites_API_v1.csv":
        df = pd.read_csv(url).astype({
            "CampsiteID": "int64",
            "FacilityID": "string",
            "CampsiteName": "string",
            "CampsiteType": "string",
            "TypeOfUse": "string",
            "Loop": "string",
            "CampsiteAccessible": "bool",
            "CampsiteLongitude": "float64",
            "CampsiteLatitude": "float64",
            "CreatedDate": "datetime64[ns]",
            "LastUpdatedDate": "datetime64[ns]"
        })
    elif file_name=="PermitEntrances_API_v1.csv":
        df = pd.read_csv(url).astype({
            "PermitEntranceID": "int64",
            "PermitEntranceType": "string",
            "FacilityID": "string",
            "PermitEntranceName": "string",
            "PermitEntranceDescription": "string",
            "District": "string",
            "Town": "string",
            "PermitEntranceAccessible": "bool",
            "Longitude": "float64",
            "Latitude": "float64",
            "CreatedDate": "datetime64[ns]",
            "LastUpdatedDate": "datetime64[ns]"
        })
    elif file_name=="Links_API_v1.csv":
        df = pd.read_csv(url).astype({
            "LinkID": "string",
            "LinkType": "string",
            "EntityID": "string",
            "EntityType": "string",
            "Title": "string",
            "Description": "string",
            "URL": "string"
        })
    elif file_name=="Activities_API_v1.csv":
        df = pd.read_csv(url).astype({
            "ActivityID": "int64",
            "ActivityParentID": "int64",
            "ActivityName": "string",
            "ActivityLevel": "int64"
        })
    elif file_name=="OrgEntities_API_v1.csv":
        df = pd.read_csv(url).astype({
            "EntityID": "string",
            "OrgID": "int64",
            "EntityType": "string"
        })
    elif file_name=="RecAreas_API_v1.csv":
        df = pd.read_csv(url).astype({
            "RecAreaID": "string",
            "OrgRecAreaID": "string",
            "ParentOrgID": "int64",
            "RecAreaName": "string",
            "RecAreaDescription": "string",
            "RecAreaUseFeeDescription": "string",
            "RecAreaDirections": "string",
            "RecAreaPhone": "string",
            "RecAreaEmail": "string",
            "RecAreaReservationURL": "string",
            "RecAreaMapURL": "string",
            "RecAreaLongitude": "float64",
            "RecAreaLatitude": "float64",
            "StayLimit": "string",
            "Keywords": "string",
            "Reservable": "bool",
            "Enabled": "bool",
            "LastUpdatedDate": "datetime64[ns]"
        })
    elif file_name=="FacilityAddresses_API_v1.csv":
        df = pd.read_csv(url).astype({
            "FacilityAddressID": "string",
            "FacilityID": "string",
            "FacilityAddressType": "string",
            "FacilityStreetAddress1": "string",
            "FacilityStreetAddress2": "string",
            "FacilityStreetAddress3": "string",
            "City": "string",
            "AddressStateCode": "string",
            "PostalCode": "string",
            "AddressCountryCode": "string",
            "LastUpdatedDate": "datetime64[ns]"
        })
    elif file_name=="Tours_API_v1.csv":
        df = pd.read_csv(url).astype({
            "TourID": "int64",
            "FacilityID": "string",
            "TourName": "string",
            "TourType": "string",
            "TourDescription": "string",
            "TourDuration": "int64",
            "TourAccessible": "bool",
            "CreatedDate": "datetime64[ns]",
            "LastUpdatedDate": "datetime64[ns]"
        })
    elif file_name=="Organizations_API_v1.csv":
        df = pd.read_csv(url).astype({
            "OrgID": "int64",
            "OrgType": "string",
            "OrgName": "string",
            "OrgImageURL": "string",
            "OrgURLText": "string",
            "OrgURLAddress": "string",
            "OrgAbbrevName": "string",
            "OrgJurisdictionType": "string",
            "OrgParentID": "int64",
            "LastUpdatedDate": "datetime64[ns]"
        })
    elif file_name=="Events_API_v1.csv":
        df = pd.read_csv(url).astype({
            "EventID": "int64",
            "EntityID": "string",
            "EntityType": "string",
            "EventName": "string",
            "Description": "string",
            "EventTypeDescription": "string",
            "EventFeeDescription": "string",
            "EventFrequencyDescription": "string",
            "EventScopeDescription": "string",
            "EventAgeGroup": "bool",
            "EventRegistrationRequired": "string",
            "EventADAAccess": "string",
            "EventComments": "string",
            "EventEmail": "string",
            "EventURLAddress": "string",
            "EventURLText": "string",
            "EventStartDate": "string",
            "EventEndDate": "string",
            "SponsorName": "string",
            "SponsorClassType": "string",
            "SponsorPhone": "string",
            "SponsorEmail": "string",
            "SponsorURLAddress": "string",
            "SponsorURLText": "string",
            "LastUpdatedDate": "datetime64[ns]"
        })
    elif file_name=="MemberTours_API_v1.csv":
        df = pd.read_csv(url).astype({
            "MemberTourID": "int64",
            "TourID": "int64",
            "TourName": "string"
        })
    elif file_name=="PermitEntranceZones_API_v1.csv":
        df = pd.read_csv(url).astype({
            "PermitEntranceZoneID": "int64",
            "PermitEntranceID": "int64",
            "Zone": "string"
        })
    elif file_name=="PermitEntranceAttributes_API_v1.csv":
        df = pd.read_csv(url).astype({
            "AttributeID": "int64",
            "AttributeName": "string",
            "AttributeValue": "string",
            "EntityID": "string",
            "EntityType": "string"
        })
    elif file_name=="TourAttributes_API_v1.csv":
        df = pd.read_csv(url).astype({
            "AttributeID": "int64",
            "AttributeName": "string",
            "AttributeValue": "string",
            "EntityID": "string",
            "EntityType": "string"
        })
    elif file_name=="RecAreaAddresses_API_v1.csv":
        df = pd.read_csv(url).astype({
            "RecAreaAddressID": "int64",
            "RecAreaID": "int64",
            "RecAreaAddressType": "string",
            "RecAreaStreetAddress1": "string",
            "RecAreaStreetAddress2": "string",
            "RecAreaStreetAddress3": "string",
            "City": "string",
            "PostalCode": "string",
            "AddressStateCode": "string",
            "AddressCountryCode": "string",
            "LastUpdatedDate": "datetime64[ns]"
        })
    elif file_name=="RecAreaFacilities_API_v1.csv":
        df = pd.read_csv(url).astype({
            "RecAreaID": "string",
            "FacilityID": "string"
        })
    elif file_name=="EntityActivities_API_v1.csv":
        df = pd.read_csv(url).astype({
            "ActivityID": "int64",
            "ActivityDescription": "string",
            "ActivityFeeDescription": "string",
            "EntityID": "string",
            "EntityType": "string"
        })
    elif file_name=="PermittedEquipment_API_v1.csv":
        df = pd.read_csv(url).astype({
            "CampsiteID": "int64",
            "MaxLength": "int64",
            "EquipmentName": "string"
        })
    else:
        df = pd.read_csv(url)
    return df

@task(log_prints=True)
def clean(df: pd.DataFrame, year: int, file_name: str) -> pd.DataFrame:
    """Fix dtype issues"""
    if year == 2019 or year == 2020:
        df = df.drop(columns=["customerstate", "customercountry"])
    else: True
    
    print(f"\nrows: {len(df)}\ncolumns:\n{df.dtypes}\n{df.head(2)}")    
    return df


@task(log_prints=True)
def write_local(df: pd.DataFrame, local_path: str) -> Path:
    """Write DataFrame out locally as parquet file"""
    path = Path(f"data/ridb/parquet/{local_path.replace('_API_v1','').replace('.csv','')}.parquet")
    df.to_parquet(path, compression="gzip")
    return path


@task(log_prints=True)
def write_gcs(path: Path) -> None:
    """Upload local parquet file to GCS"""
    gcs_block = GcsBucket.load("gcs-decap")
    gcs_block.upload_from_path(from_path=path, to_path=path)
    return


@flow(log_prints=True)
def etl_web_to_gcs(year: int, path: str) -> None:
    """The main ETL function"""
    if year == 0:
        url = f"data/ridb/RIDBFullExport_V1_CSV/{path}"
        file_name = path
    else:
        url = path
        file_name = f"{year}"

    print(f"\nyear: {year}, file_name: {file_name}, path: {url}")
    df = fetch(url, year, file_name)
    df_clean = clean(df, year, file_name)
    parq_path = write_local(df_clean, file_name)
    write_gcs(parq_path)

@flow(log_prints=True)
def etl_parent_flow(year: int, url: str):
    etl_web_to_gcs(year, url)

if __name__ == "__main__":
    # Check whether the specified path exists or not
    if os.path.exists(f"data/ridb/RIDBFullExport_V1_CSV.gz") == False:
        download("https://github.com/brettdavies/de-zoomcamp/raw/main/data/ridb/RIDBFullExport_V1_CSV.gz","data/ridb/RIDBFullExport_V1_CSV.gz")

    if os.path.exists(f"data/ridb/RIDBFullExport_V1_CSV.gz"):
        ridbfull = tarfile.open("data/ridb/RIDBFullExport_V1_CSV.gz")
        ridbfull.extractall("data/ridb")
        for name in ridbfull.getnames():
            if (name == "RIDBFullExport_V1_CSV" or name.startswith("RIDBFullExport_V1_CSV/.") or name.startswith(".")) == False:
                etl_parent_flow(0, name.replace("RIDBFullExport_V1_CSV/",""))

    for year in range(4):
        year += 2019
        path = ""
        
        # Check whether the specified path exists or not
        if os.path.exists(f"data/ridb/reservations{year}.csv.gz"):
            path = f"data/ridb/reservations{year}.csv.gz"
        elif year == 2019 or year == 2020:
            path = f"https://github.com/brettdavies/de-zoomcamp/raw/main/data/ridb/reservations{year}.csv.gz"
        else:
            path = f"https://github.com/brettdavies/de-zoomcamp-capstone/raw/main/data/ridb/reservations{year}.csv.gz"
        
        etl_parent_flow(year, path)

# https://github.com/brettdavies/de-zoomcamp/raw/main/data/ridb/RIDBFullExport_V1_CSV.gz
# https://github.com/brettdavies/de-zoomcamp/raw/main/data/ridb/reservations2019.csv.gz
# https://github.com/brettdavies/de-zoomcamp/raw/main/data/ridb/reservations2020.csv.gz
# https://github.com/brettdavies/de-zoomcamp-capstone/raw/main/data/ridb/reservations2021.csv.gz
# https://github.com/brettdavies/de-zoomcamp-capstone/raw/main/data/ridb/reservations2022.csv.gz
