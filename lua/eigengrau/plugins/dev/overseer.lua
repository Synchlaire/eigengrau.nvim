return{
        'stevearc/overseer.nvim',
        cmd = {
            "OverseerOpen",
            "OverseerClose",
            "OverseerToggle",
            "OverseerSaveBundle",
            "OverseerLoadBundle",
            "OverseerDeleteBundle",
            "OverseerRunCmd",
            "OverseerRun",
            "OverseerInfo",
            "OverseerBuild",
            "OverseerQuickAction",
            "OverseerTaskAction ",
            "OverseerClearCache",
        },
        opts = {
            task_list = {
                direction = "bottom",
                min_height = 15,
                max_height = 15,
                default_detail = 1,
            },
        },
}
