<%@ page import="it.unitn.progettoweb.utils.Database" %>
<%@ page import="javax.xml.crypto.Data" %>
<%@ page import="it.unitn.progettoweb.Objects.AdvancedSearchParameters" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="it.unitn.progettoweb.Objects.Articolo" %>
<%@ page import="it.unitn.progettoweb.Objects.Categoria" %>
<%@ page import="it.unitn.progettoweb.Objects.QueryOrder" %><%--
  Created by IntelliJ IDEA.
  User: Federico
  Date: 22/09/2017
  Time: 14:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<%
    AdvancedSearchParameters advS1 = new AdvancedSearchParameters();
    String cat = request.getParameter("cat");
    String nameS = request.getParameter("q");
    String search = request.getParameter("search");
    AdvancedSearchParameters advS = new AdvancedSearchParameters();

    Database db = new Database();
    ArrayList<Categoria> categorie= db.getCategorie();
    ArrayList<Articolo> results = null;


    if (cat!=null && !cat.equals("Categorie")){
        Categoria categoria = new Categoria(cat,"");
        System.out.println(categoria.getNome());
        advS.setCategoria(categoria);
    }
    if(nameS != null){
        advS.setTesto(nameS);
    }
    if(search!=null){
        advS.setTesto(search);
    }
    if(nameS == null && advS1 ==null){
        results = db.getHomeLastArticles();
    }else {
        results = db.getAdvancedSearchResults(advS);
    }
    db.close();
%>


<body>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script>
    $(document).ready(function() {
        $('#list').click(function(event){event.preventDefault();$('#products .item').addClass('list-group-item');});
        $('#grid').click(function(event){event.preventDefault();$('#products .item').removeClass('list-group-item');$('#products .item').addClass('grid-group-item');});
    });

    $(document).ready(function(e){
        $('.search-panel .dropdown-menu').find('a').click(function(e) {
            e.preventDefault();
            var param = $(this).attr("href").replace("#","");
            var concept = $(this).text();
            $('.search-panel span#search_concept').text(concept);
            $('.input-group #search_param').val(param);
        });
    });
</script>
<link rel="stylesheet" type="text/css" href="styles/shopstyle.css">

<div class="shop-container ">
    <div class="well well-sm row">
        <div class="col-md-4 col-sm-12 display">
        <strong>Display</strong>
        <div class="btn-group">
            <a href="#" id="list" class="btn btn-default btn-sm"><span class="glyphicon glyphicon-th-list">
            </span>List</a> <a href="#" id="grid" class="btn btn-default btn-sm"><span
                class="glyphicon glyphicon-th"></span>Grid</a>
        </div>
        </div>
        <form action="./shop.jsp" class="form">
            <div class="input-group mb-3">
                    <select type="button" class="ricerca btn btn-default dropdown-toggle custom-select input-group-prepend" data-toggle="dropdown" name="cat">
                        <option class="opzioniCat">Categorie</option>
                        <%
                            System.out.println(""+categorie.size());
                            if (categorie.size()>0){
                                for (int i =0; i<categorie.size(); i++){
                        %>

                        <option class="opzioniCat" value="<%=categorie.get(i).getNome()%>"><%=categorie.get(i).getNome()%></option>
                        <%
                                }
                            }
                        %>
                    </select>
                    <input type="text" name="x" class="custom-file ricerca custom-file-input" id="inputGroupFile03">


                        <button class="btn btn-outline-secondary ricerca" class="input-group-prepend" type="submit"><span class="glyphicon glyphicon-search"></span></button>


            </div>
        </form>

<!--
        <div class="">
            <div class="">
                <form action="./shopbody.jsp" method="GET">
                    <div class="col-xs-12 col-md-8 gruppo">
                        <div class="input-group">
                            <div class="ricerca input-group-btn search-panel">


                                <input type="hidden" name="search_param" value="all" id="search_param">
                                <input type="text" class="ricerca form-control form-control-input" name="search" placeholder="Search term...">
                                <span class="input-group-btn">
                                    <button class="btn btn-default ricerca" type="submit" id="searchbtn"><span class="glyphicon glyphicon-search"></span></button>

                                    </span>

                            </div>
                        </div>

                    </div>
                </form>
            </div>
        </div>
-->

        </div>
    </div>
    <div class="container2 container row">
            <div id="filter-panel" class="collapse filter-panel">
                <div class="panel panel-default">
                    <div class="panel-body">
                        <form class="form-inline" role="form">
                            <div class="form-group">
                                <!--
                                <label class="filter-col"  for="pref-search">Search:</label>
                                <input type="text" class="form-control input-sm" id="pref-search">
                                -->
                                <label class="filter-col">Price<span class="span">from:</span></label>
                                <input type="number" class="form-control input-sm" name="priceFrom" id="price-from">
                                <label class="filter-col"><span class="span">to:</span></label>
                                <input type="number" class="form-control input-sm" name="priceTo" id="price-to">
                            </div>
                            <!-- form group [search] -->
                            <div class="form-group">
                                <label class="filter-col" style="margin-right:0;" for="pref-orderby">Order by:</label>
                                <select name="order-by" id="pref-orderby" class="form-control">
                                    <option value="desc">Price: descendent</option>
                                    <option value="asc">Price: increasing</option>

                                </select>
                            </div> <!-- form group [order by] -->
                            <div class="form-group">
                                <label class="filter-col">Review average:</label>
                                <select id="sort-review" class="form-control" name="rev">Review
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                </select>
                            </div>
                            <div class="row form-group" id="filter-bottom">
                                <div class="checkbox" style="margin-left:10px; margin-right:10px;">
                                    <label><input type="checkbox"> Remember parameters</label>
                                </div>
                                <button type="submit" class="btn btn-default filter-col" onclick="advancedResearch()">
                                    <span class="glyphicon glyphicon-record"></span> Save Settings
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <button type="button" class="btn btn-primary pull-right" data-toggle="collapse" data-target="#filter-panel">
                <span class="glyphicon glyphicon-cog"></span> Advanced Search
            </button>
    </div>
</div>
<div class="niente" id="no-item">There isn't any item for your search</div>
    <div id="products" class="row list-group">

        <div class="articoli-box" id="">
            <div class="row" id="shop-content">


            </div>

        </div>

    </div>

</body>
<%
    //TODO: query per la ricerca
%>
<script>

    $(document).ready(function (){
    <%
        if(results.size()!=0){
             %>
        document.getElementById("no-item").style.display = "none"
        <%
            for(int i =0; i< results.size(); i++){
               %>

            $('#shop-content').append(new_item("<%=results.get(i).getIdArticolo()%>","<%=results.get(i).getDescrizione()%>", "<%=results.get(i).getTitolo()%>","<%=results.get(i).getPrezzo()%>"));
            <%
            }
        }
        else{
            %>
            document.getElementById("no-item").style.display = "block"
        <%
        }
    %>


    });
    function new_item(id,descrizione,titolo,prezzo){
        return (
            '<div class="item  col-xs-12 col-md-3 col-lg-3">\n' +
            '            <div class="thumbnail">\n' +
            '                <img class="group list-group-image" src="http://placehold.it/400x250/000/fff" alt="" />\n' +
            '                <div class="caption">\n' +
            '                    <h4 class="group inner list-group-item-heading"><a href="../../item.jsp?id='+id+'">'+titolo+'</a></h4> '+
            '                    <p class="group inner list-group-item-text">'+descrizione+'</p>\n' +
            '                    <div class="row">\n' +
            '                        <div class="col-xs-12 col-md-6">\n' +
            '                            <p class="lead">'+prezzo+'</p>\n' +
            '                        </div>\n' +
            '                        <div class="col-xs-12 col-md-6">\n' +
            '                            <a class="btn btn-success" href="../../utils/cart.jsp?action=aggiungi&idArticolo='+id+'">Add to cart</a>\n' +
            '                        </div>\n' +
            '                    </div>\n' +
            '                </div>\n' +
            '            </div>\n' +
            '        </div>'

        );


    }

    function advancedResearch(){

        <%
                   String searchItem ;
                   int revAverage;

                   int priceFrom=-10, priceTo=-10;
                   Database db1 = new Database();
                   ArrayList<Articolo> results1 = null ;

                   QueryOrder order;
                   if(request.getParameter("priceFrom")!= null){
                      if (!request.getParameter("priceFrom").equals("")){
                            priceFrom = Integer.parseInt(request.getParameter("priceFrom") );
                            advS1.setStartPrice(priceFrom);
                      }
                   }
                    if(request.getParameter("priceTo")!=null){
                       if (!request.getParameter("priceTo").equals("")){
                            priceTo = Integer.parseInt(request.getParameter("priceTo"));
                            advS1.setEndPrice(priceTo);
                        }
                    }
                    if(request.getParameter("rev")!=null){
                        if (!request.getParameter("rev").equals("")){
                            revAverage = Integer.parseInt(request.getParameter("rev"));
                            advS1.setMinReview(revAverage);
                        }
                    }
                    if(request.getParameter("order-by")!= null){
                       if(request.getParameter("order-by").equals("desc") ){
                           order = QueryOrder.DESC;
                       } else{
                           order = QueryOrder.ASC;
                       }

                       advS1.setQueryOrder(order);
                   }

                    if(nameS!=null){
                        if(!nameS.equals("")){
                                advS1.setTesto(nameS);
                        }
                    }

                   results1 = db1.getAdvancedSearchResults(advS1);

                   db1.close();
        System.out.println("result UNO size" + results1.size() + "result " + results.size());
              if(results1.size()!=0){
                  System.out.println(results1.size());
                                %>
        document.getElementById("no-item").style.display = "none"
        <%
            for(int i =0; i< results1.size(); i++){
                System.out.println(results1.get(i).getVoto());
               %>
        $("#shop-content").append(new_item("<%=results1.get(i).getIdArticolo()%>","<%=results1.get(i).getDescrizione()%>","<%=results1.get(i).getTitolo()%>","<%=results1.get(i).getPrezzo()%>"));
        <%
        }
    }
    else{
        %>
        document.getElementById("no-item").style.display = "block";
    <%
    }
%>
    }

</script>
