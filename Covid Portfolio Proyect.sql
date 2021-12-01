/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/


SELECT *
FROM dbo.covidDeaths
ORDER BY 3,4


SELECT *
FROM dbo.covidDeaths
ORDER BY 3,4

--Select data that i am going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM dbo.covidDeaths
ORDER BY 1,2

--Loking at TotalCases vs Total Deaths
--Shows likelihood of dying if your contract covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM dbo.covidDeaths
WHERE location = 'mexico'
ORDER BY 1,2

-- Looking at Total cases vs Population
--Shows what percentage of population got covid

SELECT location, date, total_cases, population, (total_cases/population)*100 as CasesPercentage
FROM dbo.covidDeaths
WHERE location = 'mexico'
ORDER BY 1,2

--Looking at countries with the highest infection rate conpared to population

SELECT location,  max(total_cases) as HighestInfectionCount, population, max((total_cases/population))*100 as PercentagePopulationInfected
FROM dbo.covidDeaths
WHERE continent is NOT NULL
GROUP BY population, location
ORDER BY PercentagePopulationInfected DESC

-- Showing countries with highest death count

SELECT location, max(cast(total_deaths as bigint)) as HighestDeathsCount
FROM dbo.covidDeaths
WHERE continent is NOT NULL
GROUP BY population, location
ORDER BY HighestDeathsCount DESC

-- Showing continent with highest death count

SELECT continent, max(cast(total_deaths as bigint)) as HighestDeathsCount
FROM dbo.covidDeaths
WHERE continent is NOT NULL
GROUP BY continent
ORDER BY HighestDeathsCount DESC

-- Global numbers

SELECT SUM(new_cases) as Total_cases, SUM(cast(new_deaths as bigint)) as Total_deaths, SUM(cast(new_deaths as bigint))/SUM(new_cases) as DeathPercentage --total_cases, total_deaths, (total_deaths/total_cases)*100 DeathPercentage
FROM dbo.covidDeaths
WHERE continent is NOT NULL
--GROUP BY date
order by 1,2

--Looking at total population vs vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER(Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
FROm dbo.covidDeaths dea
Join dbo.covidVaccinations vac
 ON dea.location = vac.location
 AND dea.date = vac.date
WHERE dea.continent is NOT NULL
ORDER BY 2,3

-- Using CTE to perform Calculation on Partition By in previous query

WITH popvsvac (continent, location, date, population, new_vaccinated, PeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER(Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
FROm dbo.covidDeaths dea
Join dbo.covidVaccinations vac
 ON dea.location = vac.location
 AND dea.date = vac.date
WHERE dea.continent is NOT NULL
--ORDER BY 2,3
)
SELECT *, (PeopleVaccinated/population)*100 PercentageVaccinated
FROM popvsvac



-- Creating View to store data for later visualizations

--Create a view 1

Create view PercentPeopleVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER(Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
FROm dbo.covidDeaths dea
Join dbo.covidVaccinations vac
 ON dea.location = vac.location
 AND dea.date = vac.date
WHERE dea.continent is NOT NULL
--ORDER BY 2,3

SELECT *
FROM PercentPeopleVaccinated

--Create a view 2

Create view TotalPopulationvsVaccination as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER(Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
FROm dbo.covidDeaths dea
Join dbo.covidVaccinations vac
 ON dea.location = vac.location
 AND dea.date = vac.date
WHERE dea.continent is NOT NULL
--ORDER BY 2,3

--Create a view 3

Create view GlobalNumbers as
SELECT SUM(new_cases) as Total_cases, SUM(cast(new_deaths as bigint)) as Total_deaths, SUM(cast(new_deaths as bigint))/SUM(new_cases) as DeathPercentage --total_cases, total_deaths, (total_deaths/total_cases)*100 DeathPercentage
FROM dbo.covidDeaths
WHERE continent is NOT NULL
--GROUP BY date
--order by 1,2

--Create a view 4

Create view ContinenWithHighestDeath as
SELECT continent, max(cast(total_deaths as bigint)) as HighestDeathsCount
FROM dbo.covidDeaths
WHERE continent is NOT NULL
GROUP BY continent
--ORDER BY HighestDeathsCount DESC

--Create a view 5

Create view CountriesWithHighestDeathCount as
SELECT location, max(cast(total_deaths as bigint)) as HighestDeathsCount
FROM dbo.covidDeaths
WHERE continent is NOT NULL
GROUP BY population, location
--ORDER BY HighestDeathsCount DESC

--Create a view 6

Create view countriesWithTheHighestInfectionRateConparedtoPopulation as
SELECT location, max(total_cases) as HighestInfectionCount, population, max((total_cases/population))*100 as PercentagePopulationInfected
FROM dbo.covidDeaths
WHERE continent is NOT NULL
GROUP BY population, location
--ORDER BY PercentagePopulationInfected DESC

--Create a view 7

Create view WhatPercentageofPopulationGotCovid as
SELECT location, date, total_cases, population, (total_cases/population)*100 as CasesPercentage
FROM dbo.covidDeaths
WHERE location = 'mexico'
--ORDER BY 1,2

--Create a view 8

Create view Likelihood_of_dyingif_your_contract_covid_in_your_country as
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM dbo.covidDeaths
WHERE location = 'mexico'
--ORDER BY 1,2