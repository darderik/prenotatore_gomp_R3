var mainList = document.getElementById("slotListBody");
var chld = mainList.children;
let res;
var results = [];
const regexp = new RegExp("\\d{2}\\/\\d{2}\\/\\d{4}\\s+\\d{2}:\\d{2}");

for (let index = 0; index < chld.length; index++) {
    const curRow = chld[index];
    var curText = curRow.innerText;
    var curRes = curText.match(regexp);
    results.push(curRes[0]);
}

return results;