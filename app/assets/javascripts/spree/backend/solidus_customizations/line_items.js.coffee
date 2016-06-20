onAddCustomization = (e) ->
  e.preventDefault()
  line_item = $(this).closest('.line-item')
  line_item_id = line_item.data('line-item-id')
  quantity = parseInt(line_item.find('input.line_item_quantity').val())
  price = parseFloat(line_item.find('input.line_item_price').val())
  medium = $(this).data('medium')
  size = $(this).data('size')
  configuration_id = $(this).data('configuration-id')
  source_id = $(this).data('source-id')
  SelectDesign medium, size, (design) ->
    addCustomization(line_item_id, quantity, price, design, configuration_id, source_id)

onEditCustomization = (e) ->
  e.preventDefault()
  line_item = $(this).closest('.line-item')
  line_item_id = line_item.data('line-item-id');
  design_id = $(this).data('design-id')
  customization_id = $(this).data('customization-id')
  CreateDesign design_id, (design) ->
    editCustomization(line_item_id, design.id, customization_id)


$(document).ready ->
  $('.line-item')
  .on('click', '.add-customization', onAddCustomization)
  .on('click', '.edit-customization', onEditCustomization)


lineItemURL = (id) ->
  "#{Spree.routes.line_items_api(order_number)}/#{id}.json"

customizationUrl = (line_item_id, id) ->
  "#{Spree.routes.customizations_api(line_item_id)}/#{id}.json"

addCustomization = (line_item_id, quantity, price, design, configuration_id, source_id) ->
  url = lineItemURL(line_item_id)
  data = JSON.stringify(
    line_item:
      quantity: quantity
      options:
        price: price
        customizations_attributes: [
          article_id: design.id
          article_type: 'Spree::Design'
          configuration_id: configuration_id
          configuration_type: 'Spree::DesignConfiguration'
          source_id: source_id
          source_type: 'Spree::DesignOption'
        ]
  )
  Spree.ajax(
    type: "PUT",
    url: url,
    contentType: "application/json"
    data: data
  ).done (msg) ->
    window.Spree.advanceOrder()

editCustomization = (line_item_id, design_id, customization_id) ->
  url = customizationUrl(line_item_id, customization_id)
  Spree.ajax(
    type: "PUT",
    url: url,
    data:
      customization:
        article_id: design_id
  ).done (msg) ->
    window.Spree.advanceOrder()