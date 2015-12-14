angular.module('app', [])

.controller('MyController', function ($scope, $http) {
    $scope.items = []

    $scope.getItems = function() {
     $http({method : 'GET',url : '/api/v1/object/list', headers: {}})
        .success(function(data, status) {
          console.log(data);
            $scope.items = data;
         })
        .error(function(data, status) {
            alert("Error");
        })
    }
});
