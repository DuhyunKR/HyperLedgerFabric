<!DOCTYPE html>
<html>
  <head>
		<title>fabcar prototype</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" 
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	</head>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" 
      integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" 
      crossorigin="anonymous"></script>
  
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <body>
      <div class="container">
          <div class="container">
            <br>
            <h2>차량조회 페이지</h2>
            <p>차량조회 필요한 정보를 입력하세요</p>

                <label class="form-label" for="carid">차량ID</label><br>
                <input class="form-control" type="text" id="carid" name="carid"><br><br>
                <button id="query-button" class="btn btn-outline-info">차량조회</button>
                &nbsp;&nbsp;&nbsp;<button id="history-button" class="btn btn-outline-info">이력조회</button>
                &nbsp;&nbsp;&nbsp;<a href="/" class="btn btn-outline-secondary">홈으로</a>

            <br>
          </div>
      <br>
      <div class ="card">
          <div class="card-header">
              RESULT:
          </div>
          <div class="card-body">
              <p id="query-result"></p>
              <table id="result_table" class="table table-hover table-dark">
                  <thead id="result_table_head">
                  </thead>
                  <tbody id="result_table_body">
                  </tbody>
              </table>
          </div>
      </div>
    </div>  
  </body>

  
  <script>
      $('#query-button').click(() => {
          const carid = $('#carid').val();
          console.log("query-button clicked ", carid);

          $.get('/car', {carid}, (data, status) => {
              console.log(status, data);

              $("#query-result").empty();
              $("#query-result").append(data);
          })
      })

      $('#history-button').click(() => {
          const carid = $("#carid").val();
          console.log("history-button clicked ", carid);

          $.get('/car/history', {carid}, (data, status) => {
              console.log(status, data);
              
              $("#query-result").empty();

              $("#query-result").append('result code :'+data.result+'<br>');

              $("#query_table_head").empty();
              $("#query-table_body").empty();

              if(data.result == 'success') {
                for(var i=0; i<data.content.length ; i++)
                {
                    $("#result_table_body").append("<tr><td>TxID:</td><td>" + data.content[i].txid + "</td></tr>");
                    $("#result_table_body").append("<tr><td>Timestamp:</td><td>" + data.content[i].timestamp + "</td></tr>");
                    $("#result_table_body").append("<tr><td>isDelete:</td><td>" + data.content[i].isdeleted + "</td></tr>");

                    var record = "Maker: " + data.content[i].record.make + "<br>" + "Model: " + data.content[i].record.model +
                    "<br>" + "Color: " + data.content[i].record.colour + "<br>" + "Owner: " + data.content[i].record.owner +
                    "<br>"

                    $("$result_table_body").append("<tr><td>Record:</td><td>" + record + "</td></trd>");
                }
              }
              
              {
                $("#query-result").append(i+'<br>');
                $("#query-result").append('txid: '+data.content[i].txid+'<br>');
                $("#query-result").append('record: '+JSON.stringify(data.content[i].record)+'<br>');
                $("#query-result").append('timestamp: '+data.content[i].timestamp+'<br>');
                $("#query-result").append('isdeleted: '+data.content[i].isdeleted+'<br>');

              }
          })
      })
  </script>
</html>
