:- module(server, [server/1]).

/** <module> HTTP server module
 *
 * This module implements the database server. It is primarily composed
 * of a number of RESTful APIs which exchange information in JSON format
 * over HTTP. This is intended as a mechanism for interprocess
 * communication via *API* and not as a fully fledged high performance
 * server.
 *
 * * * * * * * * * * * * * COPYRIGHT NOTICE  * * * * * * * * * * * * * * *
 *                                                                       *
 *  This file is part of TerminusDB.                                      *
 *                                                                       *
 *  TerminusDB is free software: you can redistribute it and/or modify    *
 *  it under the terms of the GNU General Public License as published by *
 *  the Free Software Foundation, under version 3 of the License.        *
 *                                                                       *
 *                                                                       *
 *  TerminusDB is distributed in the hope that it will be useful,         *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of       *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        *
 *  GNU General Public License for more details.                         *
 *                                                                       *
 *  You should have received a copy of the GNU General Public License    *
 *  along with TerminusDB.  If not, see <https://www.gnu.org/licenses/>.  *
 *                                                                       *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

:- use_module(core(triple)).
:- use_module(core(util/utils)).

% configuration predicates
:- use_module(config(terminus_config),[]).

% http server
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/html_write)).


load_jwt_conditionally :-
    config:jwt_public_key_path(JWTPubKeyPath),
    (   JWTPubKeyPath = ''
    ->  true
    ;   use_module(library(jwt_io)),
        config:jwt_public_key_id(Public_Key_Id),
        set_setting(jwt_io:keys, [_{kid: Public_Key_Id,
                                    type: 'RSA',
                                    algorithm: 'RS256',
                                    public_key: JWTPubKeyPath}])).

:- load_jwt_conditionally.

server(_Argv) :-
    config:server(Server),
    config:server_port(Port),
    config:worker_amount(Workers),
    config:http_options(HTTPOptions),
    http_server(http_dispatch,
		        [ port(Port),
		          workers(Workers)
		          | HTTPOptions
		        ]),
        setup_call_cleanup(
	    http_handler(root(.), busy_loading,
			 [ priority(1000),
			   hide_children(true),
			   id(busy_loading),
                           time_limit(infinite),
			   prefix
			 ]),
            (   triple_store(_Store), % ensure triple store has been set up by retrieving it once
                print_message(banner, welcome('terminus-server', Server))
            ),
	    http_delete_handler(id(busy_loading))).


% See https://github.com/terminusdb/terminus-server/issues/91
%  TODO replace this with a proper page
%
busy_loading(_) :-
    reply_html_page(
        title('Still Loading'),
        \loading_page).

loading_page -->
    html([
        h1('Still loading'),
        p('TerminusDB is still synchronizing backing store')
    ]).

:- multifile prolog:message//1.

prolog:message(welcome('terminus-server', Server)) -->
         [ '~N% Welcome to TerminusDB\'s terminus-server!',
         nl,
         '% You can view your server in a browser at \'~s/console\''-[Server],
         nl,
         nl
         ].