// This file belongs to the book "Introduction to Vala Programming" – https://leanpub.com/vala
// (C) 2017 Dr. Michael 'Mickey' Lauer – GPLv3

const string DirblePrefixURL = "http://api.dirble.com/v2";
const string DirbleToken = "afdecd241069030f6c04bac10c";
const string DirbleGetPrimaryCategoriesURL = DirblePrefixURL + "/categories/primary?token=%s";
const string DirbleGetChildCategoriesURL = DirblePrefixURL + "/categories/%s/childs?token=%s";
const string DirbleGetStationsURL = DirblePrefixURL + "/category/%u/stations?token=%s";

public delegate void StringCompletionHandler( uint statusCode, Json.Node rootNode );

public class DirbleClient : Object
{
    private Soup.Session _session;
    private static DirbleClient __instance;
    
    private DirbleClient()
    {
        _session = new Soup.Session();
    }
    
    //
    // API
    //
    public static DirbleClient sharedInstance()
    {
        if ( __instance == null )
        {
            __instance = new DirbleClient();
        }
        
        return __instance;
    }
    
    public async GenreModel[]? loadGenres()
    {
        GenreModel[] result = null;
        
        var url = DirbleGetPrimaryCategoriesURL.printf( DirbleToken );
        loadJsonForURL( url, ( statusCode, rootNode ) => {
            
            if ( statusCode == 200 )
            {
                var genres = new GenreModel[] {};
                var array = rootNode.get_array();
                for ( uint i = 0; i < array.get_length(); ++i )
                {
                    var object = array.get_object_element( i );
                    var genre = new GenreModel.fromJsonObject( object );
                    genres += genre;
                }
                result = genres;            
            }
        } );
        
        return result;
    }
    
    public async StationModel[]? loadStations( GenreModel genre )
    {
        StationModel[] result = null;
        
        var url = DirbleGetStationsURL.printf( genre.id, DirbleToken );
        loadJsonForURL( url, ( statusCode, rootNode ) => {
            
            if ( statusCode == 200 )
            {
                var stations = new StationModel[] {};
                var array = rootNode.get_array();
                for ( uint i = 0; i < array.get_length(); ++i )
                {
                    var object = array.get_object_element( i );
                    var station = new StationModel.fromJsonObject( object );
                    stations += station;
                }
                result = stations;
            }
                        
        } );    
        
        return result;    
    }
    
    //
    // Helpers
    //
    public void loadJsonForURL( string url, StringCompletionHandler block )
    {
        var message = new Soup.Message( "GET", url );
        assert( message != null );
#if 0 // ASYNC API BROKEN
        _session.queue_message( message, ( session, msg ) => {
            print( "GET %s => %u\n%s\n", url, msg.status_code, (string) msg.response_body.data );
            var rootnode = Json.from_string( (string) msg.response_body.data );
            block( msg.status_code, rootnode  );
        } );
#else
        _session.send_message( message );
        print( "GET %s => %u\n%s\n", url, message.status_code, (string) message.response_body.data );
        var rootnode = Json.from_string( (string) message.response_body.data );
        block( message.status_code, rootnode  );
#endif
    }
    
}

