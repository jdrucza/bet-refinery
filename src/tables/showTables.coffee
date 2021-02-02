import Tabulator from 'tabulator-tables'
import markets from '~/static/data/golf_mapping/market.json'
import aliases from '~/static/data/golf_mapping/aliases.json'

export default {
  showTables: ()->
    mobileView = window?.innerWidth < 700
    @.tableData = @.tableData or {}
    for tableEl in document.getElementsByName('brtable')
      dataFileName = tableEl.getAttribute('data-file-name')
      dataApiName = tableEl.getAttribute('data-api-name')
      if dataFileName?
        tableDataResponse = await @.$axios.get("/data/#{dataFileName}")
        tableData = tableDataResponse?.data
        @.tableData[dataFileName] = tableData
      else if dataApiName?
        console.log { dataApiName }
        apiUrl = "https://api.betrefinery.com/predictions/#{dataApiName}"
        # apiUrl = "http://localhost:1337/predictions/#{dataApiName}"
        tableDataResponse = await @.$axios.get(apiUrl)
        tableData = tableDataResponse?.data
        @.tableData[dataApiName] = tableData
      height = tableEl.getAttribute('height')
      tableConfig =
        data: tableData
        reactiveData: true
        height: height if height?
        layout: if mobileView then "fitDataFill" else "fitColumns"
        autoColumns: true
        autoColumnsDefinitions: (definitions)->
          for definition in definitions
            definition.visible = false if /.*Id$/.test(definition.title)
          definitions
      tableInstance = new Tabulator(tableEl, tableConfig)

  # TODO: this belongs in its own file
  updateOdds: (marketName, data, aliases)->
    # oddsUrl = "https://api.betrefinery.com/odds/golf/#{marketName}"
    oddsUrl = "http://localhost:1337/odds/golf/#{marketName}"
    oddsResponse = await @.$axios.get(oddsUrl)
    console.log { oddsResponse }
    oddsData = oddsResponse.data
}