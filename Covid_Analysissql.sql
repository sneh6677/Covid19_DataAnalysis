SELECT * From CovidDeaths
where continent is not NULL
Order by 1,2;

SELECT * FROM CovidVaccinations;

SELECT Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
Order by 1,2;

--Looking at Total Cases v/s Total deaths

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As Total
From CovidDeaths
WHERE Location = 'India' 
Order by 1,2;

---Looking at the total cases v/s population: what percentage of the population has gotten Covid

SELECT Location, date, total_cases, population, (total_deaths/population)*100 As CovidPercentage
From CovidDeaths
WHERE Location like '%states'
Order by 1,2;

-- What countries with hieghest infection rate compared to the population

SELECT Location, Population, MAX(total_cases) As Highest_Infect_count, Max((total_deaths/population))*100 As CovidPercentage
From CovidDeaths
GROUP BY population, Location 
ORDER by Highest_Infect_count DESC

--Show the countries with the highest death count per population
SELECT Location, Population, MAX(total_deaths) As Highest_death_count
From CovidDeaths
where continent is not NULL
GROUP BY population, Location 
ORDER by Highest_death_count DESC

---By Continent
SELECT continent, MAX(total_deaths) As Highest_death_count
From CovidDeaths
where continent is not NULL
GROUP BY continent 
ORDER by Highest_death_count DESC

--Global numbers

SELECT date, SUM(new_cases) As Cases, SUM(new_deaths) As Deaths
From CovidDeaths
WHERE continent is NOT null
GROUP by date
Order by 1,2;

---Looking at total population v/s vaccination

SELECT dea.[location], dea.[date], dea.continent, dea.population, Vac.new_vaccinations
FROM CovidVaccinations Vac 
JOIN CovidDeaths dea 
ON Vac.location = dea.location
AND vac.[date] = dea.[date]
WHERE dea.continent is NOT null
ORDER BY 1,2,3

--Use CTE to find total number of people vaccinated in that country

WITH PopVsVac (Continent, Location, date, Population,new_vaccinations, RollingPeopleVaccinated)
as 
(SELECT dea.[location], dea.[date], dea.continent, dea.population, Vac.new_vaccinations,
SUM(Vac.new_vaccinations) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidVaccinations Vac 
JOIN CovidDeaths dea 
ON Vac.location = dea.location
AND vac.[date] = dea.[date]
WHERE dea.continent is NOT null
)
Select * , (RollingPeopleVaccinated/Population) * 100
FROM PopVsVac

---creating view to store data for future visualization
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.[location], dea.[date], dea.continent, dea.population, Vac.new_vaccinations,
SUM(Vac.new_vaccinations) OVER (Partition by dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidVaccinations Vac 
JOIN CovidDeaths dea 
ON Vac.location = dea.location
AND vac.[date] = dea.[date]
WHERE dea.continent is NOT null

SELECT * FROM PercentPopulationVaccinated