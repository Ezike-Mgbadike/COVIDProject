Select *
From portfolioproject..CovidDeaths
order by 3,4

--Select *
--From portfolioproject..CovidVaccinations
--order by 3,4

---SELECT THE DATA THAT WILL BE USED

Select Location, date, total_cases, new_cases, total_deaths, population
From portfolioproject..CovidDeaths
order by 1,2

---- TOTAL CASES VS TOTAL DEATHS

--Select Location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
--From portfolioproject..CovidDeaths
--order by 1,2

--Select Location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
--From portfolioproject..CovidDeaths
--Where location like '%Africa%'
--order by 1,2

--- TOTAL CASES VS POPULATION (% of population with covid)

----Select Location, date, population, total_cases, (CONVERT(float, population) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
----From portfolioproject..CovidDeaths
----Where location like '%Africa%'
----order by 1,2

--- COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION

----Select Location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
----From portfolioproject..CovidDeaths
----Group By Location, population
------Where location like '%Africa%'
----order by PercentPopulationInfected desc

--- Countries with Highest Death Count Per Population


--Select Location, MAX(cast(Total_Deaths as int)) as TotalDeathCount
--From portfolioproject..CovidDeaths
--Group By Location
--order by TotalDeathCount desc

--Select *
--From portfolioproject..CovidDeaths
--Where continent is not null

--Select Location, MAX(cast(Total_Deaths as int)) as TotalDeathCount
--From portfolioproject..CovidDeaths
--Where continent is not null
--Group By Location
--order by TotalDeathCount desc

--- Analyze by Continent

--Select continent, MAX(cast(Total_Deaths as int)) as TotalDeathCount
--From portfolioproject..CovidDeaths
--Where continent is not null
--Group By continent
--order by TotalDeathCount desc

-- Global Analysis

--Select date, population, total_cases, (CONVERT(float, population) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
--From portfolioproject..CovidDeaths
----Where location like '%Africa%'
--where continent is not null
--order by 1,2

--Select date, SUM(new_cases)--, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
--From portfolioproject..CovidDeaths
----Where location like '%Africa%'
--where continent is not null
--Group By date
--order by 1,2



--Select SUM([new_cases]) as total_cases, SUM([new_deaths]) as total_deaths,SUM([new_deaths])/SUM([new_cases])*100 as DeathPercentage
--   From portfolioproject..CovidDeaths
--   --Where location like '%Africa%'
--   where continent is not null
--   --Group By date
--   order by 1,2


--Select *
--From portfolioproject..CovidDeaths dea
--Join portfolioproject..CovidVaccinations vac
--   On dea.location = vac.location
--   and dea.date = vac.date

-- Looking at the Total Population Vs Vaccination

--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--From portfolioproject..CovidDeaths dea
--Join portfolioproject..CovidVaccinations vac
--   On dea.location = vac.location
--   and dea.date = vac.date
--   where dea.continent is not null
--   order by 1,2,3




--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition By dea.location Order by dea.location, 
--  dea.date ROWS UNBOUNDED PRECEDING) as RollingPeopleVaccinated
--From portfolioproject..CovidDeaths dea
--Join portfolioproject..CovidVaccinations vac
--   On dea.location = vac.location
--   and dea.date = vac.date
-- Where dea.continent is not null
--   order by 2,3


--With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
--as
--(
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition By dea.location Order by dea.location, 
--  dea.date ROWS UNBOUNDED PRECEDING) as RollingPeopleVaccinated
--  --, (RollingPeopleVaccinated/population)*100
--From portfolioproject..CovidDeaths dea
--Join portfolioproject..CovidVaccinations vac
--    On dea.location = vac.location
--     and dea.date = vac.date
-- Where dea.continent is not null
--   --order by 2,3
--   )
   --Select *, (RollingPeopleVaccinated/Population)*100 as PercentageRollingPeopleVaccinated
   --From PopvsVac



--   CREATE Table #PercentPopulationVaccinated
--   (
--   Continent nvarchar(255),
--   Location nvarchar(255),
--   Date datetime,
--   Population numeric,
--   New_Vaccinations numeric,
--   RollingPeopleVaccinated numeric
--   )

--   Insert into #PercentPopulationVaccinated
--   Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition By dea.location Order by dea.location, 
--  dea.date ROWS UNBOUNDED PRECEDING) as RollingPeopleVaccinated
--  --, (RollingPeopleVaccinated/population)*100
--From portfolioproject..CovidDeaths dea
--Join portfolioproject..CovidVaccinations vac
--    On dea.location = vac.location
--     and dea.date = vac.date
-- Where dea.continent is not null
--   --order by 2,3

--      Select *, (RollingPeopleVaccinated/Population)*100 as PercentageRollingPeopleVaccinated
--   From #PercentPopulationVaccinated


Drop Table if exists #PercentPopulationVaccinated
   CREATE Table #PercentPopulationVaccinated
   (
   Continent nvarchar(255),
   Location nvarchar(255),
   Date datetime,
   Population numeric,
   New_Vaccinations numeric,
   RollingPeopleVaccinated numeric
   )

   Insert into #PercentPopulationVaccinated
   Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition By dea.location Order by dea.location, 
  dea.date ROWS UNBOUNDED PRECEDING) as RollingPeopleVaccinated
  --, (RollingPeopleVaccinated/population)*100
From portfolioproject..CovidDeaths dea
Join portfolioproject..CovidVaccinations vac
    On dea.location = vac.location
     and dea.date = vac.date
 --Where dea.continent is not null
   --order by 2,3

      Select *, (RollingPeopleVaccinated/Population)*100 as PercentageRollingPeopleVaccinated
   From #PercentPopulationVaccinated

   ---Create View to store data for later visualization

   Create View PercentPopulationVaccinated as

   Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition By dea.location Order by dea.location, 
  dea.date ROWS UNBOUNDED PRECEDING) as RollingPeopleVaccinated
  --, (RollingPeopleVaccinated/population)*100
From portfolioproject..CovidDeaths dea
Join portfolioproject..CovidVaccinations vac
    On dea.location = vac.location
     and dea.date = vac.date
 Where dea.continent is not null
   --order by 2,3
