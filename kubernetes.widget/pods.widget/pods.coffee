# Execute the shell command.
command: "kubernetes.widget/pods.widget/pods.sh"

# Set the refresh frequency (milliseconds).
refreshFrequency: 1000

# Render the output.
render: (output) -> """
  <table id='pods'>
    <tr class='pod pod-header'>
      <th>Namespace</th>
      <th>Name</th>
      <th>Ready</th>
      <th>Status</th>
      <th>Restarts</th>
    </tr>
  </table>
"""

# Update the rendered output.
update: (output, domEl) -> 
  dom = $(domEl)

  # # Parse the JSON created by the shell script.
  data = JSON.parse output

  html = ""
  # # Loop through the pods in the JSON.
  for item in data.items
    status_class_colour = if (item.status.phase is "Running" || item.status.phase is "Succedded") then 'green' else 'red'
    total_status_count  = if (item.status.containerStatuses != undefined) then item.status.containerStatuses.length
    ready_status_count  = if (item.status.containerStatuses != undefined  ) then item.status.containerStatuses.reduce (x, y) -> 
      x + (y.ready ? 1 : 0)
    , 0
    restart_count       =  if (item.status.containerStatuses != undefined  ) then item.status.containerStatuses.reduce (x, y) -> 
      x + y.restartCount
    , 0
    
    html +="
      <tr class='pod pod-item'>
        <td>#{item.metadata.namespace}</td>
        <td>#{item.metadata.name}</td>
        <td>#{ready_status_count}/#{total_status_count}</td>
        <td class='#{status_class_colour}'>#{item.status.phase}</td>
        <td>#{restart_count}</td>
      </tr>"

  # Set output.
  $("#pods .pod-item").remove()
  $("#pods .pod-header").after(html)

  # $(pods).html(html)

# CSS Style
style: """
  margin:0
  padding:0px
    // Position this where you want
  top 50px
  right 20px
  width:auto
  background:rgba(#666, .5)
  border:1px solid rgba(#000, .25)
  border-radius:5px
  
  .pod
    text-align:left
    padding:20px
    font-size:10pt
    font-weight:bold
    font: 10px arial, sans-serif;

  .pod .red
    color: rgba(#f00,0.75)

  .pod .green
    color: rgba(#0f0,0.75)

  .pod td
    color: rgba(#A9A9A9)
    padding: 1px 5px
  
  .pod th
    color: rgba(#fff)
    padding: 1px 5px
"""
