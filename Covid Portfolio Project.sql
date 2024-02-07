SELECT *
FROM [Project Portfolio].dbo.CovidDeaths
order by 3,4;

SELECT *
FROM [Project Portfolio].dbo.CovidVaccinations
order by 3,4;

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM [Project Portfolio].dbo.CovidDeaths
order by 1,2;

-- death percentage
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM [Project Portfolio].dbo.CovidDeaths
Where location = 'India'
order by 1,2;

-- cases percentage

SELECT Location, date, total_cases, population, (total_cases/population)*100 As CasesPercentage
FROM [Project Portfolio].dbo.CovidDeaths
where Location like '%Indi%'
order by 1,2

--Highest infection rate according to population

Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From [Project Portfolio].dbo.CovidDeaths
Group by Location, population
order by PercentPopulationInfected desc;


--highest death count
SELECT Location, population, MAX(cast(total_deaths as int)) as HighestDeathCount
FROM [Project Portfolio].dbo.CovidDeaths
Group by Location, population
order by HighestDeathCount desc;


-- highest death count based on continents

SELECT continent, population, MAX(cast(total_deaths as int)) as HighestDeathCount
FROM [Project Portfolio].dbo.CovidDeaths
where continent is not null
Group by continent, population
order by HighestDeathCount desc;




SELECT *
FROM [Project Portfolio].dbo.CovidVaccinations
order by 3,4;

--total population vs vaccinations

SELECT deat. continent, deat. location, deat. date, deat. population, vac. new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER (partition by deat.Location order by deat.location, deat.Date) as RollingPeopleVaccinated
FROM [Project Portfolio].dbo.CovidDeaths as deat
JOIN [Project Portfolio].dbo.CovidVaccinations as vac
ON deat.location = vac.location
AND deat. date = vac. date
where deat.continent is not NULL
order by 1,2,3


--using CTE's

With PopvsVac (continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT deat. continent, deat. location, deat. date, deat. population, vac. new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER (partition by deat.Location order by deat.location, deat.Date) as RollingPeopleVaccinated
FROM [Project Portfolio].dbo.CovidDeaths as deat
JOIN [Project Portfolio].dbo.CovidVaccinations as vac
ON deat.location = vac.location
AND deat. date = vac. date
where deat.continent is not NULL
)
Select * , (RollingPeopleVaccinated/Population)*100 as RollingPeopleVaccinatedPercentage
From PopvsVac


--temp table

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
SELECT deat. continent, deat. location, deat. date, deat. Population, vac. new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER (partition by deat.Location order by deat.location, deat.Date) as RollingPeopleVaccinated
FROM [Project Portfolio].dbo.CovidDeaths as deat
JOIN [Project Portfolio].dbo.CovidVaccinations as vac
ON deat.location = vac.location
AND deat. date = vac. date
where deat.continent is not NULL
Select * , (RollingPeopleVaccinated/Population)*100 as RollingPeopleVaccinatedPercentage
From #PercentPopulationVaccinated


-- creating view to store data for visualisations

Create View PercentPopulationVaccinated as
SELECT deat. continent, deat. location, deat. date, deat. Population, vac. new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER (partition by deat.Location order by deat.location, deat.Date) as RollingPeopleVaccinated
FROM [Project Portfolio].dbo.CovidDeaths as deat
JOIN [Project Portfolio].dbo.CovidVaccinations as vac
ON deat.location = vac.location
AND deat. date = vac. date
where deat.continent is not NULL

select *
from PercentPopulationVaccinated