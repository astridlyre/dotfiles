import moonlight.draw

# Load existing settings made via :set
config.load_autoconfig()

c.qt.args = ["enable-gpu-rasterization", "ignore-gpu-blocklist", "enable-accelerated-video-decode"]

moonlight.draw.blood(c, {
    'spacing': {
        'vertical': 0,
        'horizontal': 2
    }
})
