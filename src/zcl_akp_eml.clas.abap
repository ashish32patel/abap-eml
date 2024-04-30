CLASS zcl_akp_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS eml_read
      IMPORTING
        i_out TYPE REF TO if_oo_adt_classrun_out.
    METHODS eml_read_by_association
      IMPORTING
        i_out TYPE REF TO if_oo_adt_classrun_out.
    METHODS eml_update
      IMPORTING
        i_out TYPE REF TO if_oo_adt_classrun_out.
    METHODS eml_create
      IMPORTING
        i_out TYPE REF TO if_oo_adt_classrun_out.

ENDCLASS.



CLASS zcl_akp_eml IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*    eml_read( out ).
    eml_read_by_association( out ).

*    eml_update( out ).
*    eml_create( out ).


  ENDMETHOD.


  METHOD eml_update.

    DATA update_tab TYPE TABLE FOR UPDATE /DMO/I_Carrier_S.
    update_tab = VALUE #( ( AirlineID = 'AF' Name = 'Air France' ) ).

    MODIFY ENTITIES OF /DMO/I_CarriersLockSingleton_S
    ENTITY Carrier
    UPDATE FIELDS ( Name )
    WITH update_tab.

    COMMIT ENTITIES.

  ENDMETHOD.


  METHOD eml_read.

    DATA input_keys TYPE TABLE FOR READ IMPORT /dmo/i_carrier_s.
    DATA result_tab TYPE TABLE FOR READ RESULT /dmo/i_carrier_s.

    input_keys = VALUE #( ( AirlineID = 'AA' )
                           ( AirlineID = 'DL' ) ).

    READ ENTITIES OF /DMO/I_CarriersLockSingleton_S
    ENTITY Carrier
    ALL FIELDS WITH input_keys
    RESULT result_tab
    FAILED DATA(failed)
    REPORTED DATA(reported).


    i_out->write(
      EXPORTING
        data = result_tab
    ).

  ENDMETHOD.


  METHOD eml_read_by_association.
    "multiple READ operations on multiple entities of a RAP BO

    READ ENTITIES OF /DMO/I_Travel_U
    ENTITY Travel
    ALL FIELDS WITH VALUE #( ( %key-TravelID = '00000004' ) )
*    RESULT DATA(travelData)
    RESULT FINAL(travelData)

    ENTITY Travel
    BY \_Booking              "Read by association
    ALL FIELDS WITH VALUE #( ( %key-TravelID = '00000004' ) )
    RESULT FINAL(travel_Booking_Data)

    ENTITY Booking
    ALL FIELDS WITH VALUE #( ( %key-TravelID = '00000002' %key-BookingID = '0001') )
    RESULT DATA(bookingData)

    FAILED DATA(failed)
    REPORTED DATA(reported).

    i_out->write(
      EXPORTING
        data = travelData
        name = 'Travel entity data:'
    ).

    i_out->write(
      EXPORTING
        data = travel_Booking_Data
        name = 'Booking data from Travel entity via association:'
    ).

    i_out->write(
      EXPORTING
        data = bookingdata
        name = 'Booking data :'
    ).

    READ ENTITIES OF /DMO/I_Travel_U
    ENTITY Travel
    BY \_Booking              "Read by association
    ALL FIELDS WITH VALUE #( ( %key-TravelID = '00000004' ) )
    LINK DATA(rba_travel_booking_linkeddata).
  ENDMETHOD.


  METHOD eml_create.

  ENDMETHOD.
ENDCLASS.
