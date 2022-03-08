
library(shiny)
library(shinydashboard)

source("functions.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    chat_data <- reactive({
        
        req(input$v_chat_data)
        
        data <- input$v_chat_data
        
        if (is.null(data)) {
            return(NULL)
        }
        
        else {
            df_data <-  rwa_read(data$datapath) %>%
                filter(!is.na(author),
                       !text %in% c("Se eliminó este mensaje", "This message was deleted")) %>%
                mutate(time = as.Date(time))
        }
        
        #return(df_data)
        
    })
    
    collect_bigrams <- reactive({
        req(chat_data())
        
        tt_collect_bigram(chat_data())
    }) %>% 
        bindCache(chat_data())
    
    
    output$v_no_chat <- renderValueBox({
        
        no_chat <- tt_mesages(chat_data())
        valueBox(
            value = h4(tags$b(no_chat)),
            subtitle = tags$em("chats sent"),
            icon = icon("comments"),
            color = "green"
        )
    })
    
    output$v_no_users <- renderValueBox({
        
        no_users <- tt_users(chat_data())
        valueBox(
            value = h4(tags$b(no_users)),
            subtitle = tags$em("users has been in this chat"),
            #icon = icon("people"),
            color = "green"
        )
    })
    
    output$v_most_active <- renderValueBox({
        
        active_user <- tt_active_user(chat_data()) 
        valueBox(
            value = h4(tags$b(active_user$author)),
            subtitle = tags$em(paste("is most active user with",
                             active_user$n, "chats")),
            icon = icon("user-check"),
            color = "olive"
        )
    })
    
    ### Most active
    
    output$v_avg_msg <- renderValueBox({
        
        req(chat_data())
        
        max_len <- tt_get_avg_chatter(chat_data())
        valueBox(
            value = h4(tags$b(max_len$author)),
            subtitle = tags$em(paste("chats are quite wordy, with an average of",
                             max_len$n, "words per message")),
            #icon = icon("person"),
            color = "olive"
        )
    })
    
    output$v_least_active <- renderValueBox({
        
        
        
        least_active_user <- tt_least_active_user(chat_data()) 
        
        chat_or_chats <- ifelse(least_active_user$n == 1, "chat", "chats")
        
        valueBox(
            value = h4(tags$b(least_active_user$author)),
            subtitle = tags$em(paste("has the least chat, with a total",
                             least_active_user$n, chat_or_chats)),
            icon = icon("user-minus"),
            color = "green"
        )
    })
    
    output$v_emoji_user <- renderValueBox({
        
        emoji_user <- tt_who_uses_emoji_mostly(chat_data()) 
        
        valueBox(
            value = h4(tags$b(emoji_user$author)),
            subtitle = tags$em(paste("is the Emoji Boss, they used it ",
                             emoji_user$n, "times")),
            icon = icon("trophy"),
            color = "green"
        )
    })
    
    output$v_most_used_emoji <- renderValueBox({
        
        most_used_emoji <- tt_extract_most_used_emoji(chat_data()) 
        
        valueBox(
            value = sprintf(most_used_emoji$emoji),
            subtitle = tags$em(paste("is the most used emoji, it has been used",
                             most_used_emoji$n, "times")),
            icon = icon("icons"),
            color = "olive"
        )
    })
    
    output$v_emoji_user_stat <- renderValueBox({
        
        top_user <- tt_who_uses_emoji_mostly(chat_data())$author
        top_emoji <- tt_extract_most_used_emoji(chat_data())$emoji
            
        emoji_user_stat <- top_emoji_user_stat(chat_data(),
                                               top_user = top_user,
                                               top_emoji = top_emoji) 
        
        if(length(emoji_user_stat$author != 0)){
            
            valueBox(
                value = h4(tags$b(paste0(emoji_user_stat$perc,"%"))),
                subtitle = tags$em(paste(top_user, "used", sprintf(top_emoji) ,
                                 emoji_user_stat$n, "times")),
               # icon = icon("face-grin-tears"),
                color = "olive"
            )
            
        } else {
            
            valueBox(
                value = sprintf("\U0001f633"),
                subtitle = tags$em(paste(top_user, "hasn't used", sprintf(top_emoji))),
               # icon = icon("face-surprise"),
                color = "green"
            )
        }
        
       
    })
    
    output$v_who_sends_media_most <- renderValueBox({
        
        most_media <- tt_who_sends_media_most(chat_data()) 
        
        valueBox(
            value = h4(tags$b(most_media$author)),
            subtitle = tags$em(paste("sends multimedia files the most (",
                             most_media$n, " times)", sep = "")),
            icon = icon("id-badge"),
            color = "green"
        )
    })
    
    output$v_emoji_per_message <- renderInfoBox({
        
        emoji_per_message <- tt_emoji_per_message(chat_data()) 
        
        infoBox(
            title = "Emoji to Chat rate",
            value = paste0(emoji_per_message$rate_10, " in 10 chats") ,
            subtitle = tags$em(paste("The rate ",emoji_per_message$author, "uses Emojis in their chats")),
            color = "green"
        )
    })
    
    
    output$v_top_users_plot <- renderPlotly({
        
        tt_top_users_plot(chat_data())
        
    })
    
    output$v_avg_length_plot <- renderPlotly({
        
        tt_top_avg_length_plot(chat_data())
        
    })
    
    output$v_network_plot_bigram <- renderPlot({
        
        validate(need(input$n_cnt, "Reset the Node limit"))
        
        tt_plot_bigram_network(collect_bigrams(), input$n_cnt)
        
    })
    
})
