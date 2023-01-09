select 
location, date, total_cases, new_cases, total_deaths  
from CovidEda..Coviddeaths
order by 1,2

-- Total Cases vs total deaths
--shows likelihood of dying if you contract covid in your country
select 
location, date, total_cases, total_deaths , round((total_deaths/total_cases)*100,2) as DeathPercentage  
from CovidEda..Coviddeaths
where location like 'india'
order by 1,2 

-- Total Cases vs total population

select 
location, date, Population, total_cases, round((total_cases/Population)*100,2) as ContractedCovid  
from CovidEda..Coviddeaths
where location like 'india'
order by 1,2 

--Looking at countries with Highest infection rate compared to population

select 
location,  Population, max(total_cases) as TotalCases, round(MAX((total_cases/Population)*100),2) as ContractedCovid  
from CovidEda..Coviddeaths
--where location like 'india'
group by location,  Population
order by ContractedCovid desc

-- showing countries with highest death count per population
select 
location, MAX(cast(total_deaths as int)) as TotalDeathCounts
from CovidEda..Coviddeaths
--where location like 'india'
Where continent is not null
group by location
order by TotalDeathCounts desc

--Breaking things down by continent
--higest death count per population continent wise

select 
continent, MAX(cast(total_deaths as int)) as TotalDeathCounts
from CovidEda..Coviddeaths
--where location like 'india'
Where continent is not null
group by continent
order by TotalDeathCounts desc


--Global numbers

Select 
SUM(new_cases) as total_cases , SUM(CAST(new_deaths as int)) as total_deaths 
,Round(SUM(CAST(new_deaths as int)) / SUM(new_cases) * 100,2) as Deathpercentage
from CovidEda..covidDeaths
where continent is not null
Order by 1,2

--Total population vs total vaccinations
With cte as(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over(partition by dea.location 
Order by dea.location,dea.date) as RollingVaccines 
from CovidEda..CovidDeaths as dea
join CovidEda..Covidvaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

select *, 
Round((RollingVaccines/population)*100,2) as VacOnpop
from cte
where location like 'Albania'



 


