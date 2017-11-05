//PARA FUNCIONAR COM RAILS 5 É PRECISO CHAMAR O TURBOLINKS DESTA FORMA
$(document).on('turbolinks:load', function() {

	//NEWLINE
	$("#t").html("#{simple_format title}");


   //carregar o calendário contas a pagar em portugues
   $(document).ready(function () {
        $('#data_vencto_pagar').datepicker({format: "dd/mm/yyyy", language: "pt-BR" });
      });
   $(document).ready(function () {
        $('#data_pagto').datepicker({format: "dd/mm/yyyy", language: "pt-BR" });
      });
   //-------------------------------

   //carregar o calendário contas a receber em portugues
   $(document).ready(function () {
        $('#data_vencto_receb').datepicker({format: "dd/mm/yyyy", language: "pt-BR" });
      });
   $(document).ready(function () {
        $('#data_receb').datepicker({format: "dd/mm/yyyy", language: "pt-BR" });
      });
   //-------------------------------

   //valores no cadastro de produtos
   $("#cost_value").maskMoney({symbol:"R$",decimal:".",thousands:""});
   $("#cost_sale").maskMoney({symbol:"R$",decimal:".",thousands:""});
   //-------------------------------

   //valores no cadastro de taxas
   $("#pis").maskMoney({symbol:"R$",decimal:".",thousands:""});
   $("#icms").maskMoney({symbol:"R$",decimal:".",thousands:""});
   //-------------------------------

   //-------------------------------

   $("#phone").mask("(99) 9999-9999",{placeholder:""});
   $("#phone1").mask("(99) 9999-9999",{placeholder:""});
   $("#celphone").mask("(99)99999-9999", {placeholder:""});
   $("#celphone2").mask("(99)99999-9999", {placeholder:""});
   $("#cep").mask("99999-999",{placeholder:""});
   $("#cpf").mask("999.999.999-99",{placeholder:" "});
   $("#cnpj").mask("99.999.999/9999-99",{placeholder:" "});
   $("#im").mask("999.999.999.999",{placeholder:""});
   $("#ie").mask("999.999.999.999",{placeholder:""});
   $("#placa").mask("aaa9999",{placeholder:""});
   $("#chave").mask("99999999999999999999999999999999999999999999",{placeholder:""});
   $("#ncm").mask("99999999",{placeholder:""});
   $("#cfop").mask("9999",{placeholder:""});
   $("#sleep").mask("99",{placeholder:""});
	 $("#ofone").mask("99999999999",{placeholder:""});

   //Faz a mascara de moeda do Brasil
   //maskMoney({symbol:"R$",decimal:",",thousands:"."})
   $("#real").maskMoney({symbol:"R$",decimal:".",thousands:""});

   $("#r1").maskMoney({symbol:"R$",decimal:".",thousands:""});
   $("#r2").maskMoney({symbol:"R$",decimal:".",thousands:""});
   $("#r3").maskMoney({symbol:"R$",decimal:".",thousands:""});
   $("#r4").maskMoney({symbol:"R$",decimal:".",thousands:""});
   $("#r5").maskMoney({symbol:"R$",decimal:".",thousands:""});

	 // para digitar somente numeros
  //called when key is pressed in textbox
  $("#numero").keypress(function (e) {
     //if the letter is not digit then display error and don't type anything
     if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
        //display error message
        $("#errmsg").html("Digits Only").show().fadeOut("slow");
               return false;
    }
   });

	 // para digitar somente numeros QUANTIDADE
	$("#qnt").keypress(function (e) {
		 //if the letter is not digit then display error and don't type anything
		 if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
				//display error message
				$("#errmsg").html("Digits Only").show().fadeOut("slow");
							 return false;
		}
	 });

	 //PARA ATIVAR O ENTER E IR PARA O PROXIMO CAMPO EM TODA A APLICAÇÃO
	 $('body').on('keydown', 'input, select, textarea', function(e) {
	 var self = $(this)
	   , form = self.parents('form:eq(0)')
	   , focusable
	   , next
	   , prev
	   ;

	 if (e.shiftKey) {
	  if (e.keyCode == 13) {
	      focusable =   form.find('input,a,select,button,textarea').filter(':visible');
	      prev = focusable.eq(focusable.index(this)-1);

	      if (prev.length) {
	         prev.focus();
	      } else {
	         form.submit();
	     }
	   }
	 }
	   else
	 if (e.keyCode == 13) {
	     focusable = form.find('input,a,select,button,textarea').filter(':visible');
	     next = focusable.eq(focusable.index(this)+1);
	     if (next.length) {
	         next.focus();
	     } else {
	         form.submit();
	     }
	     return false;
	 }
	 });

 });

   //deixar tudo em letra maiuscula
   //$(document).ready(function() {
   //$("input").keyup(function(){
   //PARA TUDO MAIUSCULO EU USO ESSA LINHA DE BAIXO
   // $(this).val($(this).val().toUpperCase());
   //PARA SOMENTE A PRIMEIRA LETRA MAIUSCULA EU USO ESSA LINHA DE BAIXO
   //$(this).val($(this).val().replace(/(^|\s)[a-z]/g,function(f){return f.toUpperCase();}));
   //	});
   //	});
