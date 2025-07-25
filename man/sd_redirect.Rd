% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ui.R
\name{sd_redirect}
\alias{sd_redirect}
\title{Create a Redirect Element for 'shiny' Applications}
\usage{
sd_redirect(
  id,
  url,
  button = TRUE,
  label = "Click here",
  delay = NULL,
  newtab = FALSE
)
}
\arguments{
\item{id}{A character string of a unique id to be used to identify the
redirect button in the survey body. In reactive contexts, this becomes
the output ID, while the actual button gets the ID \code{id + "_btn"} to
avoid input/output conflicts.}

\item{url}{A character string specifying the URL to redirect to.}

\item{button}{A logical value indicating whether to create a button (\code{TRUE})
or a text element (\code{FALSE}) for the redirect. Default is \code{TRUE}.}

\item{label}{A character string for the button or text label. Defaults to
\code{NULL}, in which case the words \code{"Click here"} will be used.}

\item{delay}{An optional numeric value specifying the delay in seconds before
automatic redirection. If \code{NULL} (default), no automatic redirection
occurs.}

\item{newtab}{A logical value indicating whether to open the URL in a new
tab (\code{TRUE}) or in the current tab (\code{FALSE}). Default is \code{FALSE}.}
}
\value{
In a reactive context, creates an output with the specified ID that
can be displayed using \code{sd_output()}. The actual button element gets the
ID \code{id + "_btn"} to prevent input/output conflicts. In a non-reactive
context, returns the redirect element directly.
}
\description{
This function creates a UI element that redirects the user to a specified
URL. It can be used in both reactive and non-reactive contexts within
'shiny' applications.
}
\examples{
if (interactive()) {
  library(surveydown)

  # Get path to example survey file
  survey_path <- system.file("examples", "sd_redirect.qmd",
                             package = "surveydown")

  # Copy to a temporary directory
  temp_dir <- tempdir()
  file.copy(survey_path, file.path(temp_dir, "survey.qmd"))
  orig_dir <- getwd()
  setwd(temp_dir)

  # Define a minimal server
  server <- function(input, output, session) {

    # Reactive expression that generates a url with an id variable
    # parsed from the url
    url_redirect <- reactive({
      params <- sd_get_url_pars()
      id <- params["id"]
      return(paste0("https://www.google.com?id=", id))
    })

    # Create the redirect button
    sd_redirect(
      id = "redirect_url_pars",
      url = url_redirect(),
      button = TRUE,
      label = "Redirect"
    )

    sd_skip_if(
      input$screening_question == "end_1" ~ "end_page_1",
      input$screening_question == "end_1" ~ "end_page_2",
    )

    sd_server()
  }

  # Run the app
  shiny::shinyApp(ui = sd_ui(), server = server)

  # Clean up
  setwd(orig_dir)
}
}
