import Tabulator from 'tabulator-tables'

export default {
  showTables: ()->
    for tableEl in document.getElementsByName('brtable')
      dataFileName = tableEl.getAttribute('data-file-name')
      console.log { dataFileName }
      tableDataResponse = await @.$axios.get("/data/#{dataFileName}")
      console.log { tableDataResponse }
      tableData = tableDataResponse?.data
      height = tableEl.getAttribute('height')
      tableConfig =
        data: tableData
        height: height if height?
        layout: "fitColumns"
        autoColumns: true
        autoColumnsDefinitions:
          playerId: { visible: false }
      tableInstance = new Tabulator(tableEl, tableConfig)
}