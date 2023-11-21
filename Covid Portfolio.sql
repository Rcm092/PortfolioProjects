Select *
from PortfolioProject..CovidDeaths
order by 3,4


--Select *
--from PortfolioProject..CovidDeaths
--order by 3,4

--Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%state%'
Order by 1,2


-- Looking at Total Cases vs Population
--Shows what percentage of population got Covid

Select Location, date, Population, total_cases, (total_cases/Population)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%state%'
Order by 1,2

--Looking at Countries with Highest Infection Rate compared to Population

Select Location, Population, Max(total_cases) as HighestInfectionCount, Max((total_cases/Population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%state%'
Group by Location,Population
Order by PercentPopulationInfected desc

--Showing Countries With Highest Death Count per Population

Select Location, Max(cast(total_deaths as Int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location,Population
Order by TotalDeathCount desc


-- Lets Break Things Down By Continent
--Showing the Continets with the Highest Deathcounts

Select Location, Max(cast(total_deaths as Int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location
Order by TotalDeathCount desc


Select Location, Max(cast(total_deaths as Int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location
Order by TotalDeathCount desc


--Global Numbers

Select date, Sum(new_cases) as TotalCases, Sum(cast(new_deaths as int)) as TotalDeaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%state%'
Where continent is not null
Group by date
Order by 1,2


--Looking at Total Population vs Vaccinations

--Use CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) Over (Partition by dea.Location order by dea.Location,
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2, 3
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPopulationVaccinated
From PopvsVac

--Use Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) Over (Partition by dea.Location order by dea.Location,
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2, 3

Select *, (RollingPeopleVaccinated/Population)*100 as PercentPopulationVaccinated
From #PercentPopulationVaccinated



Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as int)) Over (Partition by dea.Location order by dea.Location,
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2, 3




Create View GlobalNumbersByDate as
Select date, Sum(new_cases) as TotalCases, Sum(cast(new_deaths as int)) as TotalDeaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%state%'
Where continent is not null
Group by date
--Order by 1,2


Create View TotalDeathsByContinent as
Select Location, Max(cast(total_deaths as Int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location
--Order by TotalDeathCount desc





Create View PercentPopulationInfectedPerCountry as
Select Location, Population, Max(total_cases) as HighestInfectionCount, Max((total_cases/Population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%state%'
Group by Location,Population
--Order by PercentPopulationInfected desc
