--Cleaning Data in SQL Queries
SELECT * 
From PortfolioProject.dbo.NashvileHousing


--Standardize Data Format
SELECT SaleDateConverted, convert(date, SaleDate)
From PortfolioProject.dbo.NashvileHousing


Update NashvileHousing
SET SaleDate = Convert(date, SaleDate)

ALTER TABLE  NashvileHousing
ADD SaleDateConverted Date

Update NashvileHousing
SET SaleDateConverted = Convert(date, SaleDate)

--Populate Address Data

SELECT * --PropertyAddress
From PortfolioProject.dbo.NashvileHousing
--where PropertyAddress is null
order by ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress , ISNULL ( a.PropertyAddress, b.PropertyAddress )
From PortfolioProject.dbo.NashvileHousing a
Join PortfolioProject.dbo.NashvileHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = isnull ( a.PropertyAddress, b.PropertyAddress )
From PortfolioProject.dbo.NashvileHousing a
Join PortfolioProject.dbo.NashvileHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]

where a.PropertyAddress is null

Select PropertyAddress 
from PortfolioProject.dbo.NashvileHousing
where PropertyAddress is null



----------------------------------------------------------------------------------------------------------------------

--Break address into individual Column like city name, state etc
Select PropertyAddress, ParcelID
from PortfolioProject.dbo.NashvileHousing
order by ParcelID

Select 
substring(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress)) as Address ,
substring(PropertyAddress,  CHARINDEX(',' , PropertyAddress)+1 , len(PropertyAddress) )as Address
from PortfolioProject.dbo.NashvileHousing



ALTER TABLE  NashvileHousing
ADD PropertySplitAddress Nvarchar(260)

UPDATE NashvileHousing
SET PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress)-1)


ALTER TABLE  NashvileHousing
ADD PropertySplitCity Nvarchar(260)


UPDATE NashvileHousing
set PropertySplitCity =substring(PropertyAddress,  CHARINDEX(',' , PropertyAddress)+1 , len(PropertyAddress) )


select * 
from PortfolioProject.dbo.NashvileHousing



select OwnerAddress
from PortfolioProject.dbo.NashvileHousing



select 
parsename (Replace(OwnerAddress,',', '.'),3),
parsename (Replace(OwnerAddress,',', '.'),2),
parsename (Replace(OwnerAddress,',', '.'),1)
--parsename (Replace(OwnerAddress,',', '.'),4)
from PortfolioProject.dbo.NashvileHousing

--Adding Table and Setting values*******

ALTER TABLE  NashvileHousing
ADD OwnersSplitAddress Nvarchar(260)

UPDATE NashvileHousing
SET OwnersSplitAddress = parsename (Replace(OwnerAddress,',', '.'),3)


ALTER TABLE  NashvileHousing
ADD OwnersSplitCity Nvarchar(260)


UPDATE NashvileHousing
set OwnersSplitCity = parsename (Replace(OwnerAddress,',', '.'),2)


ALTER TABLE  NashvileHousing
ADD OwnersSplitState Nvarchar(260)


UPDATE NashvileHousing
set OwnersSplitState = parsename (Replace(OwnerAddress,',', '.'),1)


select*
from PortfolioProject.dbo.NashvileHousing


-------------------------------------------------------------------------------------------------------------------------

--Change Y to YES and N to NO in Sold in Vacant Field

Select Distinct(SoldAsVacant), COUNT (SoldAsVacant)
from PortfolioProject.dbo.NashvileHousing
GROUP BY SoldAsVacant
Order by 2


Select SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' Then 'YES'
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END
from PortfolioProject.dbo.NashvileHousing


UPDATE NashvileHousing
SET SoldAsVacant= CASE WHEN SoldAsVacant = 'Y' Then 'YES'
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
	END

-------------------------------------------------------------------------------------------------------------------------

--Remove Duplicates
WITH Row_numCTE AS(
Select *,
Row_NUMBER () OVER (
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order By
			   UniqueId
			   ) row_num
from PortfolioProject.dbo.NashvileHousing
--order by ParcelID
)
Select *
from Row_numCTE
 where row_num > 1


-------------------------------------------------------------------------------------------------------------
--Remove Unused Columns
SELECT * 
from PortfolioProject.dbo.NashvileHousing

Alter Table PortfolioProject.dbo.NashvileHousing
DROP COLUMN OWNERADDRESS, TaxDistrict, PropertyAddress, Saledate


select*
from PortfolioProject.dbo.NashvileHousing

--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------