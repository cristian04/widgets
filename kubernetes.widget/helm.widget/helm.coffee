# Execute the shell command.
command: "kubernetes.widget/helm.widget/helm.sh"

# Set the refresh frequency (milliseconds).
refreshFrequency: 1000

# Render the output.
render: (output) -> """
  <table id='charts'> 
    <tr class='chart chart-header'> 
      <th>Name</th>
      <th>Namespace</th>
      <th>Revision</th>
      <th>Status</th> 
      <th>Chart</th>
    </tr>
  </table>
"""

# Update the rendered output.
update: (output, domEl) -> 
  dom = $(domEl)

  # # Parse the JSON created by the shell script.
  data = JSON.parse output

  html = ""
  # # Loop through the charts in the JSON.
  for chart in data.Releases
    html +="
      <tr class='chart chart-item'>
        <td>#{chart.Name}</td>
        <td>#{chart.Namespace}</td>
        <td>#{chart.Revision}</td>
        <td>#{chart.Status}</td>
        <td>#{chart.Chart}</td>
      </tr>"

  # Set output.
  $("#charts .chart-item").remove()
  $("#charts .chart-header").after(html)

   #$(chart).html(html)

# CSS Style
style: """
  margin:0
  padding:0px
    // Position this where you want
  top 270px
  left 550px
  width:auto
  background:rgba(#666, .5)
  border:1px solid rgba(#000, .25)
  border-radius:5px
  
  .chart
    text-align:left
    padding:20px
    font-size:10pt
    font-weight:bold
    font: 10px arial, sans-serif;

  .chart .red
    color: rgba(#f00,0.75)

  .chart td
    color: rgba(#A9A9A9)
    padding: 1px 5px
  
  .chart th
    color: rgba(#fff)
    padding: 1px 5px
"""
