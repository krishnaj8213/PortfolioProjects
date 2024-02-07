--data cleaning using SQL

SELECT *
FROM [Project Portfolio].dbo.NashvilleHousing

--standardize date format

SELECT SaleDate
FROM [Project Portfolio].dbo.NashvilleHousing

SELECT SaleDate, Convert(Date,SaleDate)
FROM [Project Portfolio].dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = SaleDateConverted

SELECT SaleDate
FROM [Project Portfolio].dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = Convert(Date,SaleDate)

SELECT SaleDateConverted, Convert(Date,SaleDate)
FROM [Project Portfolio].dbo.NashvilleHousing


--populate property address

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Project Portfolio].dbo.NashvilleHousing as a
JOIN [Project Portfolio].dbo.NashvilleHousing as b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b. UniqueID
WHERE a.PropertyAddress is NULL

Update a
SET PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Project Portfolio].dbo.NashvilleHousing as a
JOIN [Project Portfolio].dbo.NashvilleHousing as b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b. UniqueID
WHERE a.PropertyAddress is NULL

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Project Portfolio].dbo.NashvilleHousing as a
JOIN [Project Portfolio].dbo.NashvilleHousing as b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b. UniqueID

SELECT *
FROM [Project Portfolio].dbo.NashvilleHousing

--Breaking out address into individual columns(Address,City,State)

SELECT PropertyAddress
FROM [Project Portfolio].dbo.NashvilleHousing

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
FROM [Project Portfolio].dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255)

UPDATE NashvilleHousing
SET PropertySplitAddress= SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
 ADD PropertySplitCity NVARCHAR(255)

UPDATE NashvilleHousing
SET PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

SELECT *
FROM NashvilleHousing

SELECT a.ParcelID, b.ParcelID, a.OwnerAddress, b.OwnerAddress, ISNULL(a.OwnerAddress,b.OwnerAddress)
From  NashvilleHousing as a
Join NashvilleHousing as b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.OwnerAddress is NULL

UPDATE a
SET OwnerAddress= ISNULL(a.OwnerAddress,b.OwnerAddress)
From  NashvilleHousing as a
Join NashvilleHousing as b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.OwnerAddress is NULL

SELECT *
FROM NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitCity= PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitState= PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT *
FROM NashvilleHousing

--changing Y and N to Yes and No in "Sold as vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant= 'Y' then 'Yes'
	   WHEN SoldAsVacant='N' then 'No'
       ELSE SoldAsVacant
       END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant= CASE WHEN SoldAsVacant= 'Y' then 'Yes'
	   WHEN SoldAsVacant='N' then 'No'
       ELSE SoldAsVacant
       END

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant




--removing duplicates

WITH RowNumCTE As (
SELECT *,
         ROW_NUMBER() OVER(
		 PARTITION BY ParcelID,
					  PropertyAddress,
					  SalePrice,
					  SaleDate,
					  LegalReference
					  ORDER BY
					  UniqueID
					  ) row_num
FROM NashvilleHousing
)
DELETE
FROM RowNumCTE
where row_num > 1


WITH RowNumCTE As (
SELECT *,
         ROW_NUMBER() OVER(
		 PARTITION BY ParcelID,
					  PropertyAddress,
					  SalePrice,
					  SaleDate,
					  LegalReference
					  ORDER BY
					  UniqueID
					  ) row_num
FROM NashvilleHousing
)
SELECT *
FROM RowNumCTE
where row_num > 1

--deleting unused columns

SELECT *
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate