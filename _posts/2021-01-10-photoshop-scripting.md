---
layout: post
title: Manga editlerken vakit kazanın
description: bu makalede, manga editlerken iş yükünüzü nasıl hafifletebiliriz? onu inceleyeceğiz.
tags: [photoshop, scripting]
---

Photoshop kullanırken bir çok şeyi tekrar tekrar yaptığımız olmuştur. Rutin işlerimiz oluyorsa bu gibi durumlar bize çok fazla zaman kaybettiriyor. Farkına varınca da tadımız iyice kaçıyor. Bende yakın zamanda manga editlemeye başladım, her sayfayı tek tek açıp düzenlemek gerekiyor ama bazı sayfalar birbirleri ile bağlantılı içeriği var. Bunun için `artboard` yani çalışma yüzeyi kullanarak resimleri alt alta koyuyordum. 20-30 sayfalık bölümlerde pek anlaşılmasa da 100'ün üzerinde sayfa olduğu zaman, vaktinizin ne kadar kayıp olduğunu anlıyorsunuz.

İnternette:
* Açılan sayfaları artboard'a çeviren
* Artboard'ları alt alta hizalayan

bir script araştırdım. [Anton Lyubushkin][antonL] seçilen dosyaları artboard'a çevirip açan benzer bir script hazırlamış ama yaklaşık 5.5 yıllık olduğu için doğru çalışmıyor. Şimdi gerekli parçaları ele alalım:

[antonL]: https://community.adobe.com/t5/photoshop/import-images-to-artboards/td-p/8430829

1. Dosyaları seç, kontrol et ve proje oluştur:
```javascript
var fileList = app.openDialog("Bütün manga resimlerini seçiniz.");
if (fileList != null && fileList != "") {
    var doc = app.documents.add(400, 400, 72, "Manga");
    //Her dosya için yapılacaklar.
}
```
2. Her dosya için yapılacaklar:
```javascript
for (var i = 0; i < fileList.length; i++) {
         app.open(fileList[i]);//seçilen resmi proje olarak açar
         var str = app.activeDocument.name;//açılan bütün resimleri numaralandırmak için ismini tutan bir değişken ekledik
         var res = str.split(".");//. dan sonrasını ayırdık
         newArtboard(res[0], app.activeDocument.width.value, app.activeDocument.height.value, 0, delta);//açılan resim artboarda çevirildi
         app.activeDocument.activeLayer.duplicate(doc, ElementPlacement.INSIDE);//projemize artboard'ı kopyaladık
         app.activeDocument.close(SaveOptions.DONOTSAVECHANGES);//açtığımız resmi kaydetmeden kapattık
    }
    setPositions();
    alert('Tamamlandı!');
```
3. Dosyaları hizalamak için gereken kod:
```javascript
function setPositions() {
   var doc = activeDocument,layers = doc.layers;
   var offsetY = 0,offsetX=0;
   for (var i = 0, l = layers.length; i < l; i++) {
      doc.activeLayer = layers[i];
      if (isArtBoard()) 
      {
         var abSize = getArtboardDimensions();
         var Position = doc.activeLayer.bounds;
         Position[0] = 0 - Position[0];
         Position[1] = offsetY;
         doc.activeLayer.translate(-Position[0],-Position[1]);
         offsetY += abSize[1];
         offsetX += abSize[0];
      }
   }
   function isArtBoard() {
      var ref = new ActionReference();
      ref.putEnumerated(charIDToTypeID("Lyr "), charIDToTypeID("Ordn"), charIDToTypeID("Trgt"));
      return executeActionGet(ref).getBoolean(stringIDToTypeID("artboardEnabled"));
   };

   function getArtboardDimensions() {
      var ref = new ActionReference();
      ref.putEnumerated(charIDToTypeID("Lyr "), charIDToTypeID("Ordn"), charIDToTypeID("Trgt"));
      var desc = executeActionGet(ref).getObjectValue(stringIDToTypeID("artboard")).getObjectValue(stringIDToTypeID("artboardRect"));
      var w = desc.getDouble(stringIDToTypeID("right")) - desc.getDouble(stringIDToTypeID("left"));
      var h = desc.getDouble(stringIDToTypeID("bottom")) - desc.getDouble(stringIDToTypeID("top"));
      return [w, h]
   };
}
```
4. Artboard oluşturmak için gereken kod:
```javascript
function newArtboard(_name, _w, _h, _x, _y) {
   var desc6 = new ActionDescriptor();
   var ref1 = new ActionReference();
   ref1.putClass(sTID('artboardSection'));
   desc6.putReference(cTID('null'), ref1);
   var desc7 = new ActionDescriptor();
   desc7.putString(cTID('Nm  '), _name);
   desc6.putObject(cTID('Usng'), sTID('artboardSection'), desc7);
   var desc8 = new ActionDescriptor();
   desc8.putDouble(cTID('Top '), 0);
   desc8.putDouble(cTID('Left'), 0);
   desc8.putDouble(cTID('Btom'), _h);
   desc8.putDouble(cTID('Rght'), _w);
   desc6.putObject(sTID('artboardRect'), sTID('classFloatRect'), desc8);
   executeAction(cTID('Mk  '), desc6, DialogModes.NO);
}
```
Bütün fonksiyonlarımızı tamamladıktan sonra photoshop üzerinden denediğimizde aşağıdaki videoda olduğu gibi çalışır:

<video preload="auto" poster="/assets/img/ps-thumb.png" src="/assets/video/screen-recorder-sat-feb-06-2021-00-03-56.webm" type="video/mp4" autoplay controls></video>

Videoda problem oluyor ise [Youtube][youtubelink] üzerinden ulaşabilirsiniz. Scriptin tamamına bu [Github][githublink] sayfasından ulaşabilirsiniz. Sorularınız veya önerileriniz için yorum yapmayı unutmayın!

[githublink]: https://github.com/ergulburak/PhotoshopScripts-MangaEditing
[youtubelink]: https://www.youtube.com/watch?v=msskMjMZeY4