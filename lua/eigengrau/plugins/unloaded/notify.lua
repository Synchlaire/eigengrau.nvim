return{
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    cmd = 'Notifications',
    config = function ()
require("notify").setup{
  background_colour = "#000000",
  -- animation style
  stages = "fade_in_slide_out",
  timeout = 5,
  fps = 60

}
end
}

