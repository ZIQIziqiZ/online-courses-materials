function(input, output, session){
  
  fileData <- reactiveFileReader(intervalMillis = 1000,
                                 session = session,
                                 filePath = "dataToRefresh.csv",
                                 readFunc = read.csv)
  
  dataAggregation <- reactive({
    aggData <- data.table(fileData())[,list(totalSales = sum(Amount)),
                                      by = list(SalesPerson, Day)]
    return(aggData)
  })
  
  output$updatedData <- renderDT(datatable(dataAggregation()))
  
  output$updatedPlot <- renderPlot({
    ggplot(data = dataAggregation(), aes(x = SalesPerson, y = totalSales, fill = SalesPerson)) +
      geom_col()
  })
  
}