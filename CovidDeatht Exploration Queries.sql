-- SELECT * from CovidDeaths order by 3,4

-- SELECT * from CovidVaccinations2 ORDER by 3,4

SELECT * from CovidDeaths2 WHERE continent IS NOT NULL ORDER by 3,4;

-- SELECT LOCATION, DATE, TOTAL_CASES, NEW_CASES, TOTAL_DEATHS, POPULATION
-- FROM CovidDeaths2 order by 1,2

-- Looking at Total Cases vs Total Deaths

-- select location, date, total_cases, total_deaths, CAST(total_deaths AS decimal(10,2))/total_cases*100 as DeathPercentage
-- from [Project Project]..CovidDeaths2
-- where location like '%united kingdom%'
-- order by 1,2;

-- --  look at Total Cases vs Population
-- select location, date, population, total_cases, CAST(total_cases AS decimal(10, 2))/ CAST(population as int)*100 as CovidPopulationPercentage
-- from [Project Project]..CovidDeaths2
-- where location like '%united kingdom%'
-- order by 1,2 asc;

--  Looking at Countries with Highest Infection rate compared to the Population
select location, population, 
Max(total_cases) as HighestInfectionCount, 
CAST(MAX(total_cases) AS decimal(18, 2)) / NULLIF(CAST(MAX(population) as decimal(18, 2)), 0)*100 
as PopulationPercentageInfected
from [Project Project]..CovidDeaths2
GROUP by location, population
order by PopulationPercentageInfected desc

SELECT * from CovidDeaths2


-- Show countries with highest death count per LOCATION population (CAST BECUASE OF DATA TYPE)
-- ALSO ADDING WHERE CLAUSE TO EXCLUDE CONTINENT
-- (EXPLORING DATA IF CONTINENT IS NULL IT WILL ADD THE CONTINENT AS LOCATION)
select CONTINENT, max(cast(total_deaths as int)) as TotalDeatchCount
from [Project Project]..CovidDeaths2 
WHERE CONTINENT IS NOT NULL
group by CONTINENT
order by TotalDeatchCount DESC



-- SHOW TOTAL_DEATHS PER CONTINENT
select location, max(cast(total_deaths as int)) as TotalDeatchCount
from [Project Project]..CovidDeaths2 
WHERE continent IS NULL
group by location
order by TotalDeatchCount DESC


-- LOOKING AT GLOBAL CASES (USING NEW CASES TO FIND ALL CASES)

SELECT date, SUM(new_cases)
FROM [Project Project]..CovidDeaths2 
WHERE CONTINENT IS NOT NULL
GROUP BY DATE
ORDER BY 1, 2 DESC

-- GLOBAL DEATHS(IN COMMENT SECTION I CHANEGD THE NEW_CASES DATATYPE TO FLOAT TO THE NEED TO CAST, 
-- I COULDVE CASTED BUT FOR FUTURE OPERATIONS CHANGING AT ROUTE IS QUICKER)

SELECT date, SUM(new_cases) as Total_Cases, SUm(new_deaths) as Total_Deaths, sum(new_deaths)/sum(new_cases)*100 AS GlobalDeathPercentage
FROM [Project Project]..CovidDeaths2 
WHERE CONTINENT IS NOT NULL
GROUP BY DATE
ORDER BY 1, 2 asc


-- Total cases / Deaths and the GlobalDeathPercentages = 2% GLobalDeathRate
SELECT  SUM(new_cases) as Total_Cases, SUm(new_deaths) as Total_Deaths, sum(new_deaths)/sum(new_cases)*100 AS GlobalDeathPercentage
FROM [Project Project]..CovidDeaths2 
WHERE CONTINENT IS NOT NULL
-- GROUP BY DATE
ORDER BY 1, 2 asc


-- JOIN THE TWO TABLES TOGETHER
SELECT * 
FROM [Project Project]..CovidDeaths2 dea
JOIN [Project Project]..CovidDeaths2  loc
ON dea.location = loc.location
    and dea.date = loc.date

-- Total amount of people per population vs new vaccinations

SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
FROM [Project Project]..CovidDeaths2 dea
JOIN [Project Project]..CovidVaccinations2  vac
ON dea.location = vac.location
    and dea.date = vac.date
    WHERE dea.CONTINENT IS NOT NULL
    ORDER by 2,3 


-- Find the accumilation of New Vaccinatoins per day & then see how many people are vaccinated vs the population of the location

SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(INT, new_vaccinations)) 
OVER (PARTITION BY DEA.LOCATION ORDER BY DEA.LOCATION, DEA.DATE) as New_Vaccinations_PerDay,

FROM [Project Project]..CovidDeaths2 dea
JOIN [Project Project]..CovidVaccinations2  vac
ON dea.location = vac.location
    and dea.date = vac.date
    WHERE dea.CONTINENT IS NOT NULL
    ORDER by 2,3 
