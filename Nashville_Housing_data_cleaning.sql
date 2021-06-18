-- Data cleaning using SQL Queries 
-- Dataset : Nashville Housing Data 

Select * 
from Nashville_housing..NashvilleHousing

-------------------------------------------------------------------------------------------

-- standardize date format

Select SaleDateConverted, convert(date, SaleDate) as Date
From Nashville_housing..NashvilleHousing

update NashvilleHousing
set SaleDate = convert(Date, SaleDate)

alter table NashvilleHousing
Add SaleDateConverted date; 

update NashvilleHousing
set SaleDateConverted = convert (Date, SaleDate)

-------------------------------------------------------------------------------------------

-- populate property address data

Select *
From Nashville_housing..NashvilleHousing


Select table1.ParcelID, table1.PropertyAddress, table2.ParcelID, table2.PropertyAddress
from Nashville_housing..NashvilleHousing table1
join Nashville_housing..NashvilleHousing table2 
	on table1.ParcelID = table2.ParcelID
	and table1.[UniqueID ] <> table2.[UniqueID ]
where table1.PropertyAddress is null

Update table1 
set PropertyAddress = isnull (table1.PropertyAddress, table2.PropertyAddress)
from Nashville_housing..NashvilleHousing table1 
join Nashville_housing..NashvilleHousing table2
	on table1.ParcelID = table2.ParcelID
	and table1.[UniqueID ] <> table2.[UniqueID ]
where table1.PropertyAddress is null

--------------------------------------------------------------------------------------------

--Breaking out address into individual columns (address, city, state)

Select substring(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address
, substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as City
from Nashville_housing..NashvilleHousing

alter table Nashville_housing..NashvilleHousing
Add SplitAddress nvarchar(255); 

update Nashville_housing..NashvilleHousing
set SplitAddress = substring(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) 

alter table Nashville_housing..NashvilleHousing
Add SplitCity nvarchar(255); 

update Nashville_housing..NashvilleHousing
set SplitCity = substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) 

select * 
from Nashville_housing..NashvilleHousing



select OwnerAddress
from Nashville_housing..NashvilleHousing

select
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
from Nashville_housing..NashvilleHousing

---------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select distinct(SoldAsVacant), count(SoldAsVacant)
from Nashville_housing..NashvilleHousing
group by SoldAsVacant
order by 2 

select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		END
from Nashville_housing..NashvilleHousing

update Nashville_housing..NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		END
from Nashville_housing..NashvilleHousing

----------------------------------------------------------------------------------------------------------

--Removing Duplicates


with RowNumCTE as (
Select * ,
	ROW_NUMBER() over (
	partition by ParcelID, 
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by 
					UniqueID
					) row_num

from Nashville_housing..NashvilleHousing
)

Select *
from RowNumCTE
where row_num > 1
--order by PropertyAddress

----------------------------------------------------------------------------------------------------------------------------------

-- Delete unused columns

select * 
from Nashville_housing..NashvilleHousing

alter table Nashville_housing..NashvilleHousing
drop column PropertyAddress, TaxDistrict, SaleDate

-------------------------------------------------------------------------------------------------------------------



















