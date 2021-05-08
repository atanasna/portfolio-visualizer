// api url 
//const api_url = "https://cloud.butterphant.org/api/v1?name=atanas"; 
const api_url = "https://fkk806i15d.execute-api.us-east-2.amazonaws.com/prod/v1?name=atanas"
// Defining async function 
async function getapi(url) { 
    
    // Storing response 
    console.log("-0-")
    const response = await fetch(url)
    console.log("-0-")
    // Storing data in form of JSON 
    var resp_data = await response.json(); 

    document.getElementById("cryptos_percentage").innerHTML = Math.round(resp_data.categories.cryptos.percentage*10)/10 + " %"
    document.getElementById("cryptos_percentage").style.width = Math.round(resp_data.categories.cryptos.percentage*10)/10 + "%"
    document.getElementById("commodities_percentage").innerHTML = Math.round(resp_data.categories.commodities.percentage*10)/10 + " %"
    document.getElementById("commodities_percentage").style.width = Math.round(resp_data.categories.commodities.percentage*10)/10 + "%"
    document.getElementById("equities_percentage").innerHTML = Math.round(resp_data.categories.equities.percentage*10)/10 + " %"
    document.getElementById("equities_percentage").style.width = Math.round(resp_data.categories.equities.percentage*10)/10 + "%"

    document.getElementById("cryptos_value").innerHTML = transform_value(resp_data.categories.cryptos.eur) + " €"
    document.getElementById("commodities_value").innerHTML = transform_value(resp_data.categories.commodities.eur) + " €"
    document.getElementById("equities_value").innerHTML = transform_value(resp_data.categories.equities.eur) + " €"
    document.getElementById("total_value").innerHTML = transform_value(resp_data.total.eur) + " €"

    document.body.classList.add("loaded");
}

function transform_value(val){
    thousands = parseInt(val/1000)
    result = ""
    if(thousands>0){
        tens = val-parseInt(val/1000)*1000
        result = thousands + ","
    } else {
        tens = val
    }
    if(tens < 100){
        if(tens < 10){
            result = result + "00" + tens
        }else{
            result = result + "0" + tens
        }
    } else {
        result = result + tens
    }
    return result   
}
// Calling that async function 
getapi(api_url);
