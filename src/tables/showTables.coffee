import Tabulator from 'tabulator-tables'
import markets from '~/static/data/golf_mapping/market.json'
import aliases from '~/static/data/golf_mapping/aliases.json'

capitalizeFirstLetter = (string)->
  string.charAt(0).toUpperCase() + string.slice(1);
camelCase = (snakeCase)->
  parts = snakeCase.split('-')
  firstPart = parts.shift()
  parts = (capitalizeFirstLetter(part) for part in parts)
  parts.unshift(firstPart)
  parts.join('')

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
        apiParams = {}
        for attribute in tableEl.attributes when attribute.name.startsWith("data-api-param-")
          name = camelCase(attribute.name.replace("data-api-param-",""))
          value = attribute.value
          apiParams[name] = value

        console.log { apiParams }
        tableDataResponse = await @.$axios.get(apiUrl, {params: apiParams})
        tableData = tableDataResponse?.data
        @.tableData[dataApiName] = tableData
      height = tableEl.getAttribute('height')
      useGrouping = tableEl.getAttribute('data-use-grouping')
      onlyColumns = tableEl.getAttribute('data-only-cols')?.split(',')
      exceptColumns = tableEl.getAttribute('data-except-cols')?.split(',')
      frozenColumns = tableEl.getAttribute('data-frozen-cols')?.split(',')
      leftAlignedColumns = tableEl.getAttribute('data-left-aligned-cols')?.split(',')
      tableConfig =
        data: tableData
        groupBy: "hiddenGroup" if useGrouping
        groupHeader: (value)-> value
        reactiveData: true
        height: height if height?
        # layout: if mobileView then "fitDataFill" else "fitColumns"
        layout: "fitDataFill"
        resizableColumns: if mobileView then false else true
        autoColumns: true
        autoColumnsDefinitions: (definitions)->
          for definition in definitions
            if onlyColumns?
              definition.visible = false unless (definition.field in onlyColumns)
            else if exceptColumns?
              definition.visible = false if (definition.field in exceptColumns)
            else
              definition.visible = false if /.*Id$/.test(definition.title)
            definition.visible = false if definition.title == "hiddenGroup"
            definition.frozen = true if (frozenColumns? and definition.field in frozenColumns)
            definition.hozAlign = 'right' unless (leftAlignedColumns? and definition.field in leftAlignedColumns)
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