(function () {
  return {
    init: function() {



  let icon = document.getElementById('phone_numberIcon');
    document.getElementById('phone_numberIcon').style.fontSize = '50px';

    icon.addEventListener('click', function() {
                  
                        var xhr = new XMLHttpRequest();
                        xhr.open('GET', `http://172.16.0.197:5566/CallService/Call/number=`+phone_number.value+`&operator=699`);
                        
                xhr.send();
              });
              
    }
};
}());
