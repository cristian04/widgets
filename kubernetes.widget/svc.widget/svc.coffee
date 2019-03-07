# Execute the shell command.
command: "kubernetes.widget/svc.widget/svc.sh"

# Set the refresh frequency (milliseconds).
refreshFrequency: 1000

# Render the output.
render: (output) -> """
  <table id='svcs'> 
    <tr class='svc svc-header'> 
      <th>Namespace</th>
      <th>Name</th>
      <th>Type</th> 
      <th>IP</th>
    </tr>
  </table>
"""

# Update the rendered output.
update: (output, domEl) -> 
  dom = $(domEl)

  # # Parse the JSON created by the shell script.
  data = JSON.parse output

  html = ""
  # # Loop through the svc in the JSON.
  for item in data.items
    html +="
      <tr class='svc svc-item'>
        <td>#{item.metadata.namespace}</td>
        <td>#{item.metadata.name}</td>
        <td>#{item.spec.type}</td>
        <td>#{if (item.status.loadBalancer.ingress != undefined) then item.status.loadBalancer.ingress[0].ip else item.spec.clusterIP}</td>
      </tr>"

  # Set output.
  $("#svcs .svc-item").remove()
  $("#svcs .svc-header").after(html)

  # $(svc).html(html)

# CSS Style
style: """
  margin:0
  padding:0px
    // Position this where you want
  top 400px
  left 550px
  width:auto
  background:rgba(#666, .5)
  border:1px solid rgba(#000, .25)
  border-radius:5px
  
  .svc
    text-align:left
    padding:20px
    font-size:10pt
    font-weight:bold
    font: 10px arial, sans-serif;

  .svc .red
    color: rgba(#f00,0.75)

  .svc td
    color: rgba(#A9A9A9)
    padding: 1px 5px
  
  .svc th
    color: rgba(#fff)
    padding: 1px 5px
"""
