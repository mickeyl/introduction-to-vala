project (
    'introduction-to-vala',
    'c', 'vala',
    version: '0.1.0',
)

dependencies = [
    dependency ('glib-2.0'),
    dependency ('gobject-2.0'),
    dependency ('libsoup-2.4'),
    dependency ('json-glib-1.0'),
    dependency ('gstreamer-player-1.0'),
    dependency ('gio-2.0'),
    dependency ('gtk+-3.0'),
]

net_radio_sources = files (
    'netradio/netRadio.vala',
    'netradio/mainWindow.vala',
    'netradio/fontAwesomeButton.vala',
    'netradio/stationModel.vala',
    'netradio/genreModel.vala',
    'netradio/streamModel.vala',
    'netradio/imageModel.vala',
    'netradio/directoryClient.vala',
    'netradio/playerController.vala',
    'netradio/dbusInterface.vala',
    'netradio/dbusServer.vala',
)

client_sources = files (
    'netradio/netradio-client.vala',
    'netradio/dbusInterface.vala',
)

executable('netradio', net_radio_sources, dependencies: dependencies)
executable ('netradio-client', client_sources, dependencies: dependencies)
