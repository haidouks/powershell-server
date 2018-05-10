# dockerized powershell-server

->Build Container
docker build . -t powershell-server

->Run Container
docker run -d -p 8080:8080 powershell-server

# Sample URLs 

HTML:
http://localhost:8080/app-html/html5?name=cansin

REST(Json):
http://localhost:8080/app-json/get-verb?verb=Close
http://localhost:8080/app-json/get-verb
