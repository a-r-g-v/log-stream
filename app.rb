require 'sinatra'
require 'sinatra-websocket'
require 'open3'
#require 'activerecord'
require "sinatra/reloader" if development?

set :server, 'thin'
set :sockets, []

get '/' do
  "Hello"
end

get '/log' do
  if !request.websocket?
    "require websocket"
  else
    request.websocket do |ws|
      ws.onopen do
          Open3.popen3("./command/case1.sh") do |stdin, stdout, stderr, wait_thr |
            stdin.close_write
            begin
              loop do
                IO.select([stdout, stderr]).flatten.compact.each do | io |
                  io.each do |line|
                  next if line.nil? || line.empty?
                  ws.send(line)
                end
                end
                break if stdout.eof? && stderr.eof?
              end
            rescue EOFError
            end
          end


        settings.sockets << ws
      end
      ws.onclose do
        warn("websocket closed")
        settings.sockets.delete(ws)
      end
    end
  end
end

get '/view' do
  erb :view
end
__END__
@@ view

<html>
  <body>
     <h1>Deploy Log</h1>
     <div id="msgs"></div>
  </body>

  <script type="text/javascript">
    window.onload = function(){
      (function(){
        var show = function(el){
          return function(msg){ el.innerHTML =  el.innerHTML + '<br />' + msg;   }
        }(document.getElementById('msgs'));

        var ws       = new WebSocket('ws://' + window.location.host + "/log");
        ws.onopen    = function()  { show('websocket opened'); };
        ws.onclose   = function()  { show('websocket closed'); }
        ws.onmessage = function(m) { show(m.data); };
      })();
    }
  </script>
</html>



