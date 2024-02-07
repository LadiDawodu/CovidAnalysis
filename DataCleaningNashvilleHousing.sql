-- DATA CLEANING

-- Standardicze Date Format

select * from NashvilleHousing

select saledateConverted, convert(date, saledate) as DateConverted
from NashvilleHousing

-- update NashvilleHousing set saledate = convert(date,saledate)

alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing set saledateConverted = convert(date,saledate)


-- Property Address Data
select *
from NashvilleHousing
where PropertyAddress is NULL

-- SELF JOIN
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
isnull(a.PropertyAddress, b.PropertyAddress ) 
from NashvilleHousing A
JOIN NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
-- where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing A
JOIN NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null


-- Dividing Address into seperate columns

select *
from NashvilleHousing

-- substring / charindex / delimitng


-- removing coma in substring (check the function before clean)
select
substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1) as Address
from NashvilleHousing

select
substring(PropertyAddress, 1, charindex(',', PropertyAddress)-1) as Address,
substring(PropertyAddress, charindex(',', PropertyAddress) + 1, 
len(PropertyAddress)) as Address
from NashvilleHousing

-- ADD THE TWO NEW COLUMNS TO THE EXISTING TABLE

alter table NashvilleHousing
add PropertysplitAddress NVARCHAR(255) 

update NashvilleHousing
set PropertysplitAddress = substring(PropertyAddress, 1, charindex(',', PropertyAddress)-1)


alter table NashvilleHousing
add PropertySplitCity NVARCHAR(255)

update NashvilleHousing
set PropertySplitCity = substring(PropertyAddress, charindex(',', PropertyAddress) + 1,
len(PropertyAddress))


----------------


-- OWNERS ADDRESS

SELECT parsename(replace(OwnerAddress, ',', '.'), 3),
parsename(replace(OwnerAddress, ',', '.'), 2), 
parsename(replace(OwnerAddress, ',', '.'), 1)

from NashvilleHousing
-- where OwnerAddress is not null

alter table NashvilleHousing
add OwnerSplitAddress NVARCHAR(255)
alter table NashvilleHousing
add OwnerSplitCity NVARCHAR(255)
alter table NashvilleHousing
add OwnerSplitstate NVARCHAR(255)

update NashvilleHousing
set OwnerSplitAddress = parsename(replace(OwnerAddress, ',', '.'), 3)

update NashvilleHousing
set OwnerSplitcity = parsename(replace(OwnerAddress, ',', '.'), 2)


update NashvilleHousing
set OwnerSplitstate = parsename(replace(OwnerAddress, ',', '.'), 1)






-- CHANGING VALUES IN TABLES (Y = YES, N = NO)


select distinct (SoldAsVacant), count(SoldAsVacant)
from NashvilleHousing
GROUP by SoldAsVacant
order by 2

select SoldAsVacant,
    case when SoldAsVacant = 'Y' then 'Yes'
        when SoldAsVacant = 'N' then 'No'
        else SoldAsVacant
    end
from NashvilleHousing

-- UPDATING

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
        when SoldAsVacant = 'N' then 'No'
        else SoldAsVacant
    end

-- select * from NashvilleHousing


-- REMOVING DUPLICATES 

with RowNumCTE as (

SELECT *, ROW_NUMBER() OVER
(
    PARTITION BY 
    ParcelID,
    PropertyAddress,
    SalePrice,
    SaleDate,
    LegalReference
    Order BY
    uniqueID
) row_num

from  NashvilleHousing
-- order by ParcelID
)
SELECT * from RowNumCTE
where row_num > 1
order by PropertyAddress



-- DELETE FOUND DUPLICATES
with RowNumCTE as (

SELECT *, ROW_NUMBER() OVER
(
    PARTITION BY 
    ParcelID,
    PropertyAddress,
    SalePrice,
    SaleDate,
    LegalReference
    Order BY
    uniqueID
) row_num

from  NashvilleHousing
-- order by ParcelID
)
DELETE from RowNumCTE
where row_num > 1


-----------------------------------------------



-- DELETE UNEEDED COLUMNS 


SELECT * FROM  NashvilleHousing

ALTER TABLE  NashvilleHousing DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SALEDATE