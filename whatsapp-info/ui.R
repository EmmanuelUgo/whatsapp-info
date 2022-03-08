#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(shinyjs)
library(shinycssloaders)
library(plotly)
#library(bslib)

dashboardPage(
    
    #shinyjs::useShinyjs(),

    
    title = "Whatsapp-info",
    skin = "black",
    
    dashboardHeader(
        title = "whatsapp-info"
    ),
    
    dashboardSidebar(
        
        sidebarMenu(id = "panel_id",
            
            menuItem("Dashboard", tabName = "tab_dashboard", icon = icon("chart-line")),
            menuItem("Sentiment Analysis", tabName = "tab_sentiment", icon = icon("compass")),
            menuItem("Explore", tabName = "tab_explore", icon = icon("compass")),
            menuItem("Network Graph", tabName = "tab_network", icon = icon("compass")),
            menuItem("Compare", tabName = "tab_compare", icon = icon("trophy")),
            menuItem("Extra", tabName = "tab_extra", icon = icon("trophy")),
            menuItem("About", tabName = "tab_about", icon = icon("info")),
            
            fileInput("v_chat_data", "Upload Chat Data",
                      placeholder = ".txt file", multiple = FALSE,
                      accept = c(".txt")),
            
            conditionalPanel(
                condition = "input.panel_id == 'tab_network'",
                sliderInput("n_cnt", "Set Limit", min = 10,
                            max = 100, value = 50, step = 10,ticks = F)
            )
            
        )
    ),
    
    dashboardBody(
        
        tabItems(
            
            
            tabItem("tab_dashboard",
                    
                    fluidRow(
                        theme = bslib::bs_theme(
                            version = 5,
                            bg = "#202123",
                            fg = "#B8BCC2",
                            # Controls the accent (e.g., hyperlink, button, etc) colors
                            primary = "#EA80FC",
                            secondary = "#48DAC6",
                           # base_font = font_google("quicksand"),
                            code_font = c("Courier", "monospace"),
                            heading_font = "'Helvetica Neue', Helvetica, sans-serif",
                            # Can also add lower-level customization
                            "input-border-color" = "#EA80FC"
                        ),
                         box(
                            width = 12,
                            title = "Infographics",
                            status = "success",
                            
                            withSpinner(valueBoxOutput("v_no_chat", width = 2)),
                            valueBoxOutput("v_no_users", width = 3),
                            valueBoxOutput("v_most_active", width = 3),
                            valueBoxOutput("v_avg_msg", width = 4),
                            valueBoxOutput("v_least_active", width = 4),
                            valueBoxOutput("v_emoji_user", width = 4),
                            valueBoxOutput("v_most_used_emoji", width = 4),
                            valueBoxOutput("v_emoji_user_stat", width = 4),
                            valueBoxOutput("v_who_sends_media_most", width = 4),
                            infoBoxOutput("v_emoji_per_message", width = 4)
                        )),
                    
                    fluidRow(
                        tabBox(
                            width = 12,
                            side = "right",
                            
                            tabPanel(status = "success",
                                     title = "Top 20 Users",
                                     withSpinner(plotlyOutput("v_top_users_plot"))),
                            
                            tabPanel(
                                status = "success",
                                title = "Top Lengthy chat users",
                                withSpinner(plotlyOutput("v_avg_length_plot"))
                            ),
                            
                            tabPanel(
                                status = "success",
                                title = "Most used Emojis"
                            )
                        )
                        
                    )
                    
                    ),
            
            tabItem("tab_sentiment",
            "tab_sentiment"),
            
            tabItem("tab_network",
            
            fluidPage(
                
                fluidRow(
                    
                    column(width = 12,
                           
                           withSpinner(plotOutput("v_network_plot_bigram",
                                                  width = '100%')))
                )
            )),
            
            tabItem("tab_explore",
            "tab_explore"),
            
            tabItem("tab_compare",
            "tab_compare"),
            
            tabItem("tab_extra",
            "tab_extra"),
            
            tabItem("tab_about",
            "tab_about")
        )
    )
)