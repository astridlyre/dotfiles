import moonlight.draw

# Load existing settings made via :set
config.load_autoconfig()

c.qt.args = ["enable-gpu-rasterization", "ignore-gpu-blocklist", "enable-accelerated-video-decode"]
c.content.blocking.adblock.lists = [
    'https://easylist.to/easylist/easylist.txt',
    'https://easylist.to/easylist/easyprivacy.txt',
    'https://easylist-downloads.adblockplus.org/easylistdutch.txt',
    'https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt',
    'https://www.i-dont-care-about-cookies.eu/abp/',
    'https://secure.fanboy.co.nz/fanboy-cookiemonster.txt'
]


moonlight.draw.blood(c, {
    'spacing': {
        'vertical': 0,
        'horizontal': 2
    }
})
