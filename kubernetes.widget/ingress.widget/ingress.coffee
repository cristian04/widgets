# Execute the shell command.
command: "kubernetes.widget/ingress.widget/ingress.sh"

# Set the refresh frequency (milliseconds).
refreshFrequency: 500

# Render the output.
render: (output) -> """
  <table id='ingress'>
    <tr class='ingress ingress-header'>
      <th>Name</th>
      <th>Host</th>
      <th>Address</th>
    </tr>
  </table>
"""

# Update the rendered output.
update: (output, domEl) -> 
  dom = $(domEl)

  # # Parse the JSON created by the shell script.
  data = JSON.parse(output)

  html = ""
  # # Loop through the pods in the JSON.
  for item in data.items
    # status_class_colour = if (item.status.phase is "Running") then '' else 'red'
    #ready = item.status.conditions[item.status.conditions.length-1].type;
    #uptime = new Date(item.metadata.creationTimestamp)
    #age = 1
    name = item.metadata.name
    host = item.spec.rules[0]['host']
    address = item.status.loadBalancer.ingress[0].ip

    html +="
      <tr class='ingress ingress-item'>
        <td>#{item.metadata.name}</td>
        <td>#{host}</td>
        <td>#{address}</td>
      </tr>"

  console.log(name+host+address)

  # Set output.
  $("#ingress .ingress-item").remove()
  $("#ingress .ingress-header").after(html)

# CSS Style
style: """
  margin:0px
  padding:0px
  
    // Align contents left or right
  widget-align = left

  // Position this where you want
  top 500px
  left 10px 

  width:auto
  background:rgba(#000, .5)
  border:1px solid rgba(#000, .25)
  border-radius:5px
  
  .ingress
    text-align: left
    padding: 20px
    font-size: 10pt
    font-weight: bold
    font: 10px arial, sans-serif;

  .ingress .red
    color: rgba(#f00,0.75)

  .ingress td
    color: rgba(#A9A9A9)
    padding: 1px 5px
  
  .ingress th
    color: rgba(#fff)
    padding: 1px 5px
"""
