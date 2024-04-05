Select *
From PortfolioProject.[dbo].[Covid Deaths]

Select *
From PortfolioProject.[dbo].[Covid Vaccinations]

Select *
From PortfolioProject.[dbo].[Covid Deaths]
Order by 3,4

--select the daa that we are going to be using 

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject.[dbo].[Covid Deaths]
Order by 1,2

--looking at total cases vs total deaths

Select Location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From PortfolioProject.[dbo].[Covid Deaths]
Order by 1,2

--looking at united states, shows liklihood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From PortfolioProject.[dbo].[Covid Deaths]
Where location like '%states%'
Order by 1,2

--looking at total cases vs population
--shows what percentage of population has contracted covid

Select Location, date, population, total_cases, (CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))*100 as DeathPercentage
From PortfolioProject.[dbo].[Covid Deaths]
Where location like '%states%'
Order by 1,2

Select Location, date, population, total_cases, (CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))*100 as DeathPercentage
From PortfolioProject.[dbo].[Covid Deaths]
--Where location like '%states%'
Order by 1,2

--what counties have the highest infection rate v population?

Select Location, population, MAX(total_cases) AS HighestinfectionCount, MAX((CONVERT(float, total_cases)) / NULLIF(CONVERT(float, population), 0))*100 as PercentPopulationInfected
From PortfolioProject.[dbo].[Covid Deaths]
--Where location like '%states%'
Group by Location, Population
Order by PercentPopulationInfected desc

--showing countries with highest death count per population

Select Location, MAX(cast (total_deaths as int)) as Totaldeathcount
From PortfolioProject.[dbo].[Covid Deaths]
--Where location like '%states%'
Group by Location
Order by totaldeathcount desc

Select *
From PortfolioProject.[dbo].[Covid Deaths]
Where continent is not null
Order by 3,4

Select Location, MAX(cast (total_deaths as int)) as Totaldeathcount
From PortfolioProject.[dbo].[Covid Deaths]
--Where location like '%states%'
Where continent is not null
Group by Location
Order by totaldeathcount desc

--Break things down by continent

Select continent, MAX(cast (total_deaths as int)) as Totaldeathcount
From PortfolioProject.[dbo].[Covid Deaths]
--Where location like '%states%'
--Where continent is not null
Group by continent
Order by totaldeathcount desc

Select continent, MAX(cast (total_deaths as int)) as Totaldeathcount
From PortfolioProject.[dbo].[Covid Deaths]
--Where location like '%states%'
Where continent is not null
Group by continent
Order by totaldeathcount desc

--Correct way

Select location, MAX(cast (total_deaths as int)) as Totaldeathcount
From PortfolioProject.[dbo].[Covid Deaths]
--Where location like '%states%'
Where continent is null
Group by location
Order by totaldeathcount desc

--showing continents with highest death count per population

Select continent, MAX(cast (total_deaths as int)) as Totaldeathcount
From PortfolioProject.[dbo].[Covid Deaths]
--Where location like '%states%'
Where continent is not null
Group by continent
Order by totaldeathcount desc

--Global numbers

Select Location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From PortfolioProject.[dbo].[Covid Deaths]
--Where location like '%states%'
Where continent is not null
Order by 1,2

Select date, SUM(new_cases), SUM(new_deaths)--, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From PortfolioProject.[dbo].[Covid Deaths]
--Where location like '%states%'
Where continent is not null
Group by date
Order by 1,2

Select date, SUM(new_cases), SUM(new_deaths), SUM(new_deaths)/SUM(new_cases)*100 as Deathpercentage
From PortfolioProject.[dbo].[Covid Deaths]
--Where location like '%states%'
Where continent is not null
Group by date
Order by 1,2

Select date,total_cases,total_deaths,CONVERT(DECIMAL(18, 2), (CONVERT(DECIMAL(18, 2), total_deaths) / CONVERT(DECIMAL(18, 2), total_cases)))*100 as DeathPercentage
From PortfolioProject.[dbo].[Covid Deaths]
order by 1,2

--FIX
Select SUM(new_cases) as totalcases, SUM(new_deaths) as totaldeaths,CONVERT(DECIMAL(18, 2), (CONVERT(DECIMAL(18, 2), new_cases) / CONVERT(DECIMAL(18, 2), new_deaths))*100 as DeathPercentage
From PortfolioProject.[dbo].[Covid Deaths]
Where continent is not null
order by 1,2

-- looking at total population vs vaccination (new vaccination per day)
Select *
From PortfolioProject.[dbo].[Covid Vaccinations] vac
Join PortfolioProject.[dbo].[Covid Deaths] dea
 ON dea.location = vac.location
 and dea.date = vac.date

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject.[dbo].[Covid Vaccinations] vac
Join PortfolioProject.[dbo].[Covid Deaths] dea
 ON dea.location = vac.location
 and dea.date = vac.date
 Where dea.continent is not null
 Order by 1,2,3

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as rollingpeoplevac
From PortfolioProject.[dbo].[Covid Vaccinations] vac
Join PortfolioProject.[dbo].[Covid Deaths] dea
 ON dea.location = vac.location
 and dea.date = vac.date
 Where dea.continent is not null
 Order by 2,3

 --Use CTE

 With popvsvac (Continent, location, date, population, new_vaccination, rollingpeoplevac)
 as
 (
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as rollingpeoplevac
From PortfolioProject.[dbo].[Covid Vaccinations] vac
Join PortfolioProject.[dbo].[Covid Deaths] dea
 ON dea.location = vac.location
 and dea.date = vac.date
 Where dea.continent is not null
-- Order by 2,3
 )
 Select *, (rollingpeoplevac/population)*100
 From popvsvac


 --temp table
 DROP table if exists #Percentpolutaionvaccincated
 Create table #Percentpolutaionvaccincated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date Datetime,
 Population numeric,
 new_vaccinations numeric,
 rollingpeoplevac numeric
 )

 Insert into #Percentpolutaionvaccincated
  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as rollingpeoplevac
From PortfolioProject.[dbo].[Covid Vaccinations] vac
Join PortfolioProject.[dbo].[Covid Deaths] dea
 ON dea.location = vac.location
 and dea.date = vac.date
-- Where dea.continent is not null
-- Order by 2,3

 Select *, (rollingpeoplevac/population)*100
 From #Percentpolutaionvaccincated

 --creating view to store data for later visualizations

Create View Percentpopulationvaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as rollingpeoplevac
From PortfolioProject..[Covid Deaths] dea
JOIN PortfolioProject..[Covid Vaccinations] vac
  On dea.location = vac.location 
  and dea.date = vac.date
Where dea.continent is not null

--SQL queries

--1

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..[Covid Deaths]
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..[Covid Deaths]
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..[Covid Deaths]
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..[Covid Deaths]
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc



