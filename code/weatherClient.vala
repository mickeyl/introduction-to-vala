#!/usr/bin/env vala

void main()
{
    var host = "api.apixu.com";
    var port = 80;
    var key = "f4bddf887be54dc188a111908181801";
    var city = "Neu-Isenburg";
    var query = @"/v1/current.json?key=$key&q=$city";
    var message = @"GET $query HTTP/1.1\r\nHost: $host\r\n\r\n";

    try
    {
        var resolver = Resolver.get_default();
        var addresses = resolver.lookup_by_name( host, null );
        var address = addresses.nth_data( 0 );
        print( @"Resolved $host to $address\n" );

        var client = new SocketClient();
        var addr = new InetSocketAddress( address, port );
        var conn = client.connect( addr );
        print( @"Connected to $host\n" );

        conn.output_stream.write( message.data );
        print( @"Wrote request $message\n" );

        var response = new DataInputStream( conn.input_stream );
        var status_line = response.read_line( null ).strip();
        print( @"Received status line: '$status_line'\n" );

        var headers = new HashTable<string,string>( str_hash, str_equal );
        var line = "";        
        while ( line != "\r" )
        {
            line = response.read_line( null );
            var headerComponents = line.strip().split( ":", 2 );
            if ( headerComponents.length == 2 )
            {
                var header = headerComponents[0].strip();
                var value = headerComponents[1].strip();
                headers[ header ] = value;
                print( @"Got Header: $header = $value\n" );
            }
        }
        
        var body = new string[] {};
        while ( line != null )
        {
            line = response.read_line( null );
            body += line.strip();
        }
        
        if ( ! ( "200" in status_line ) )
        {
            error( "Service did not answer with 200 OK" );
        }
        
        var jsonResponse = string.joinv( "\n", body );
        print( @"Got JSON response: $jsonResponse" );

    }
    catch (Error e)
    {
        stderr.printf( @"$(e.message)\n" );
    }
}

