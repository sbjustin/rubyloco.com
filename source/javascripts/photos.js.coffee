class PhotosView
  constructor: ->
    @source = $("#photo-template").html()
    @template = Handlebars.compile(@source)

  get_photos: ->
    url = "http://api.meetup.com/2/photos/?group_id=8825222&order=time&desc=True&offset=0&format=json&page=200&fields=&sig_id=9228642&sig=05f5138c0ffcee4bbbbd69a33edb6e591f6bcc0b&callback=loadPhotos"
    $.ajax url,
        dataType: 'jsonp'
        success: (data) =>
          @add_photo(photo) for photo in data.results
          modal = new Modal(".photo")

  add_photo: (photo) ->
    $("#photos").append @template(photo)

class Modal
  constructor: (selector) ->
    _this = this
    $(selector).click ->
      _this.show(this)
    $("#modal-background").click ->
      _this.hide()

  show: (elm) ->
    $("#modal-background").css("height", $(document).height())
    $("#modal-background").css("display", "block")
    $("#modal").css("display", "block")
    $("modal img").load ->
      $("#modal").css("top", parseInt($(window).height()/10) + $(window).scrollTop() - 15)
      img_width = parseInt($("#modal img").width())
      window_width = parseInt($(window).width())
      new_width = (window_width - img_width) / 2

      $("#modal").css("left", new_width)

    $("#modal img").attr('src', $(elm).attr("data-link"))

  hide: ->
    $("#modal").css("display", "none").html("")
    $("#modal-background").css("display", "none")

$ ->
  if $("#photos").length > 0
    photos_view = new PhotosView
    photos_view.get_photos()
