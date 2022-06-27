
## [0.0.2+11]
* **[BREAKING]** Added support for Multipart requests on Web by utlizing the cross_file package.<br>This means that you need to pass XFiles instead of Files. XFiles must have the fileName attribute set.
## [0.0.2+10] 20/06/2022

* Added support for optional multipart files.
## [0.0.2+9] 15/06/2022

* Added support for Header param.
## [0.0.2+8] 07/04/2022

* Fixed PartField annotation

## [0.0.2+7] 29/03/2022

* Support latest analyzer

## [0.0.2+6] 02/12/2021

* Support for backfit - 0.0.2+4

## [0.0.2+5] 10/11/2021

* Http Status Handling 200 - 206.
## [0.0.2+4] 25/10/2021

* Add support for list of files in multipart requests.

## [0.0.2+3] 17/09/2021

* Fixed missing endpoint and media type from Multipart requests.
* Fixed multipart request not using backfit client.
## [0.0.2+2] 16/09/2021

* Added support for deserialization of Multipart request responses.
## [0.0.2-a] 14/09/2021

* Added preliminary support for Multipart requests.
## [0.0.2] 30/08/2021

* Now using PartBuilder instead of Shared Part Builder
* \*Breaking Change\* - Use ".backfit.dart" for part files instead of ".g.dart"
## [0.0.1]

* Initial Release
