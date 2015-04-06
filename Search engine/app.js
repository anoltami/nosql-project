var express = require('express'),
    ElasticSearchClient = require('elasticsearchclient'),
    url = require('url');

var app = module.exports = express.createServer();

var connectionString = url.parse("http://localhost:9200");

var serverOptions = {
    host: connectionString.hostname,
    port: connectionString.port,
    secure: false,
    auth: {
        username: connectionString.auth ? connectionString.auth.split(":")[0] : null,
        password: connectionString.auth ? connectionString.auth.split(":")[1] : null
    }
};

var elasticSearchClient = new ElasticSearchClient(serverOptions);

var _index = "helloeverybody";
var _type = 'persons';

// Configuration

app.configure(function () {
    app.set('views', __dirname + '/views');
    app.set('view engine', 'jade');
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(app.router);
    app.use(express.static(__dirname + '/public'));
});

// Routes
app.get('/', function (req, res) {
    res.render('index', {"result":""})
});

app.get('/search', function (req, res) {
    var qryObj = {
        "query":{
            "query_string":{
                "query":req.query.q
            }
        }
    };
    elasticSearchClient.search(_index, _type, qryObj)
        .on('data',
        function (data) {
            res.render('search', { result:JSON.parse(data)})
        }).on('error', function (error) {
            res.render('search', { result:error })
        })
        .exec()
});


app.get('/index', function (req, res) {
    elasticSearchClient.createIndex(_index, {}, {}).on('data',
        function (data) {
            var commands = []
            commands.push({ "index":{ "_index":_index, "_type":_type} },{'name':'Sebastien',
                'firstname':'Patrick'});

            commands.push({ "index":{ "_index":_index, "_type":_type} },{'name':'Ibrahimovic',
                'firstname':'Zlatan'});

            commands.push({ "index":{ "_index":_index, "_type":_type} },{'name':'Merigeaux',
                'firstname':'Maxime'});

            commands.push({ "index":{ "_index":_index, "_type":_type} },{'name':'Cornille',
                'firstname':'Marie-Josée'});


            elasticSearchClient.bulk(commands, {})
                .on('data', function (data) {
                    res.render('index', {result:'Données ajoutées !'});
                })
                .on('error', function (error) {
                    res.render('index', {result:error});
                })
                .exec();

        }).on('error', function (error) {
            res.render('index', {result:error});
        }).exec();
})

var port = process.env.PORT || 5000;

app.listen(port, function () {
    console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
});
