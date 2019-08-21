// This file belongs to the book "Introduction to Vala Programming" – https://leanpub.com/vala
// (C) 2017 Dr. Michael 'Mickey' Lauer – GPLv3

public class StationModel : Object
{
    public int id { get; private set; }
    public string name { get; private set; }
    public string description { get; private set; }
    public string country { get; private set; }
    public int total_listeners { get; private set; }
    public string website { get; private set; }
    public ImageModel image { get; private set; }
    public string slug { get; private set; }

    private StreamModel[] _streams;
    
    public string streamURL {
        get {
            
            int max = _streams[0].bitrate;
            StreamModel streamWithMaxBitrate = _streams[0];
            for ( int i = 0; i < _streams.length; ++i )
            {
                StreamModel stream = _streams[i];
                if ( stream.bitrate > max )
                {
                    max = stream.bitrate;
                    streamWithMaxBitrate = stream;
                }
            }
            
            return streamWithMaxBitrate.stream;
        }
    }

    public StationModel( int id, string name = "", string description = "" )
    {
        _id = id;
        _name = name;
        _description = description;
    }

    public StationModel.fromJsonObject( Json.Object json )
    {
        _id = (int) json.get_int_member( "id" );
        _name = json.get_string_member( "name" );
        _website = json.get_string_member( "website" );
        _image = new ImageModel.fromJsonObject( json.get_object_member( "image" ) );

        _streams = new StreamModel[] {};
        var array = json.get_array_member( "streams" );
        for ( int i = 0; i < array.get_length(); ++i )
        {
            var object = array.get_object_element( i );
            var stream = new StreamModel.fromJsonObject( object );
            _streams += stream;            
        }
    }
}
