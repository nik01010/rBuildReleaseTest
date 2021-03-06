% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DataAccess_CompaniesService.R
\name{CompaniesService}
\alias{CompaniesService}
\title{Service for interacting with Companies data.}
\value{
Object of type R6Class with methods for communication with Companies data.
}
\description{
Service for interacting with Companies data.

Service for interacting with Companies data.
}
\examples{
\dontrun{
mongoConnectionString <- "mongodb+srv://admin:example"

MongoDbContext <- ApplicationDbContext$new(
  connectionString = mongoConnectionString,
  database = "ExampleDatabase",
  collection = "ExampleCollection"
)

testCompaniesService <- CompaniesService$new(dbContext = MongoDbContext)
}

}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{CompaniesService$new()}}
\item \href{#method-GetCompaniesCount}{\code{CompaniesService$GetCompaniesCount()}}
\item \href{#method-GetCompanies}{\code{CompaniesService$GetCompanies()}}
\item \href{#method-GetCompany}{\code{CompaniesService$GetCompany()}}
\item \href{#method-GetCompanyId}{\code{CompaniesService$GetCompanyId()}}
\item \href{#method-GetOldestCompanies}{\code{CompaniesService$GetOldestCompanies()}}
\item \href{#method-GetNumberOfCompaniesFoundedPerYear}{\code{CompaniesService$GetNumberOfCompaniesFoundedPerYear()}}
\item \href{#method-CreateCompany}{\code{CompaniesService$CreateCompany()}}
\item \href{#method-EditCompany}{\code{CompaniesService$EditCompany()}}
\item \href{#method-DeleteCompany}{\code{CompaniesService$DeleteCompany()}}
\item \href{#method-clone}{\code{CompaniesService$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-new"></a>}}
\if{latex}{\out{\hypertarget{method-new}{}}}
\subsection{Method \code{new()}}{
Initialize a new CompaniesService object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CompaniesService$new(dbContext, schemaValidator)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{dbContext}}{ApplicationDbContext object.}

\item{\code{schemaValidator}}{SchemaValidator object.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A new CompaniesService object.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-GetCompaniesCount"></a>}}
\if{latex}{\out{\hypertarget{method-GetCompaniesCount}{}}}
\subsection{Method \code{GetCompaniesCount()}}{
Gets the number of Companies.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CompaniesService$GetCompaniesCount()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
Integer.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-GetCompanies"></a>}}
\if{latex}{\out{\hypertarget{method-GetCompanies}{}}}
\subsection{Method \code{GetCompanies()}}{
Returns a data frame of all Companies.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CompaniesService$GetCompanies()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
Dataframe.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-GetCompany"></a>}}
\if{latex}{\out{\hypertarget{method-GetCompany}{}}}
\subsection{Method \code{GetCompany()}}{
Returns a data frame for the required Company name.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CompaniesService$GetCompany(companyName)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{companyName}}{Company name string.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
Dataframe.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-GetCompanyId"></a>}}
\if{latex}{\out{\hypertarget{method-GetCompanyId}{}}}
\subsection{Method \code{GetCompanyId()}}{
Returns the Id of the required Company name.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CompaniesService$GetCompanyId(companyName)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{companyName}}{Company name string.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
Integer.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-GetOldestCompanies"></a>}}
\if{latex}{\out{\hypertarget{method-GetOldestCompanies}{}}}
\subsection{Method \code{GetOldestCompanies()}}{
Returns a data frame of the oldest Companies, for the required limit.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CompaniesService$GetOldestCompanies(limit = 10)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{limit}}{Number of Companies to limit the results to.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
Dataframe.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-GetNumberOfCompaniesFoundedPerYear"></a>}}
\if{latex}{\out{\hypertarget{method-GetNumberOfCompaniesFoundedPerYear}{}}}
\subsection{Method \code{GetNumberOfCompaniesFoundedPerYear()}}{
Returns the number of Companies founded per year.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CompaniesService$GetNumberOfCompaniesFoundedPerYear()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
Dataframe.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-CreateCompany"></a>}}
\if{latex}{\out{\hypertarget{method-CreateCompany}{}}}
\subsection{Method \code{CreateCompany()}}{
Creates a new Company record.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CompaniesService$CreateCompany(companyDetails)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{companyDetails}}{JSON string with new Company details.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-EditCompany"></a>}}
\if{latex}{\out{\hypertarget{method-EditCompany}{}}}
\subsection{Method \code{EditCompany()}}{
Edits an existing Company record.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CompaniesService$EditCompany(companyName, newCompanyDetails)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{companyName}}{Company name string.}

\item{\code{newCompanyDetails}}{JSON string with new Company details.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-DeleteCompany"></a>}}
\if{latex}{\out{\hypertarget{method-DeleteCompany}{}}}
\subsection{Method \code{DeleteCompany()}}{
Deletes an existing Company record.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CompaniesService$DeleteCompany(companyName)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{companyName}}{Company name string.}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clone"></a>}}
\if{latex}{\out{\hypertarget{method-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{CompaniesService$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
