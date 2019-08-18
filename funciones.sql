CREATE OR REPLACE FUNCTION public.f_listar_nutriente(
    IN p_codigo_tipo_nutriente integer
)
  RETURNS TABLE(codigo integer, nombre character varying, tipo_nutriente character varying) AS
$BODY$
	
	
	begin
		return query
		select
			n.codigo_nutriente,
			n.nombre,
			tn.nombre as tipo_nutiente
		from
			nutriente n 
			inner join tipo_nutriente tn on ( n.codigo_tipo_nutriente = tn.codigo_tipo_nutriente)
		where
			
			(case p_codigo_tipo_nutriente
				when 0 then
					1=1
				else
					tn.codigo_tipo_nutriente = p_codigo_tipo_nutriente
			end)
			
		order by
			n.nombre;
	end
$BODY$
  LANGUAGE plpgsql;

select * from f_listar_nutriente(1);

select * from f_listar_fertilizante(1);

select * from f_listar_provincia('1')

CREATE OR REPLACE FUNCTION public.f_listar_fertilizante(
    IN p_codigo_tipo_fertilizante integer
)
  RETURNS TABLE(codigo integer, nombre character varying, peso numeric, componente character varying, tipo_fertilizante character varying) AS
$BODY$
	
	
	begin
		return query
		select
			f.codigo_fertilizante,
			f.nombre,
			f.peso,
			f.componente,
			tf.nombre as tipo_fertilizante
		from
			fertilizante f 
			inner join tipo_fertilizante tf on ( f.codigo_tipo_fertilizante = tf.codigo_tipo_fertilizante)
		where
			
			(case p_codigo_tipo_fertilizante
				when 0 then
					1=1
				else
					tf.codigo_tipo_fertilizante = p_codigo_tipo_fertilizante
			end)
			
		order by
			f.nombre;
	end
$BODY$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.f_listar_provincia(
    IN p_codigo_departamento character
)
  RETURNS TABLE(codigo character, nombre character varying, departamento character varying) AS
$BODY$
	
	
	begin
		return query
		select
			p.codigo_provincia,
			p.nombre,
			d.nombre as departamento
		from
			provincia p 
			inner join departamento d on ( p.codigo_departamento = d.codigo_departamento)
		where
			
			(case p_codigo_departamento
				when '0' then
					'1'='1'
				else
					d.codigo_departamento = p_codigo_departamento
			end)
			
		order by
			p.nombre;
	end
$BODY$
  LANGUAGE plpgsql;

select * from f_listar_distrito('0','0')

CREATE OR REPLACE FUNCTION public.f_listar_distrito(
    IN p_codigo_departamento character,
    IN p_codigo_provincia character)
  RETURNS TABLE(codigo character, nombre character varying, departamento character varying, provincia character varying) AS
$BODY$
	
	
	begin
		return query
		select
			d.codigo_distrito,
			d.nombre,
			de.nombre as departamento,
			p.nombre as provincia
		from
			Distrito d 
			inner join provincia p on ( d.codigo_provincia = p.codigo_provincia)
			inner join departamento de on ( d.codigo_departamento = de.codigo_departamento)
		where
			(case p_codigo_departamento
				when '0' then 
					'1'='1'
				else
					de.codigo_departamento = p_codigo_departamento
			end)
			
			and --y
			
			(case p_codigo_provincia
				when '0' then 
					'1'='1'
				else
					p.codigo_provincia = p_codigo_provincia
			end)
			
			
			
		order by
			d.nombre;
	end
$BODY$
  LANGUAGE plpgsql

CREATE OR REPLACE FUNCTION public.f_listar_agricultor(
    IN p_codigo_departamento character,
    IN p_codigo_provincia character,
    IN p_codigo_distrito character
)
  RETURNS TABLE(codigo integer, nombre character varying, direccion character varying, usuario character varying, num_celular character, departamento character varying, provincia character varying, distrito character varying) AS
$BODY$

	begin
		return query
		select
			a.codigo_agricultor,
			(a.apellido_paterno || ' ' || a.apellido_materno || ' ' || a.nombres) :: character varying as nombre,
			a.direccion,
			a.usuario as correo,
			a.num_celular as numero_celular,
			d.nombre as departamento,
			p.nombre as provincia,
			di.nombre as distrito
		from
			agricultor a 
			inner join distrito di on ( a.codigo_distrito = di.codigo_distrito)
			inner join provincia p on (di.codigo_provincia = p.codigo_provincia)
			inner join departamento d on (p.codigo_departamento = d.codigo_departamento)
		where
			
			(case p_codigo_departamento
				when '0' then
					'1'='1'
				else
					d.codigo_departamento = p_codigo_departamento
			end)

			and 

			(case p_codigo_provincia
				when '0' then
					'1'='1'
				else
					p.codigo_provincia = p_codigo_provincia
			end)

			and

			(case p_codigo_distrito
				when '0' then
					'1'='1'
				else
					di.codigo_distrito = p_codigo_distrito
			end)
			
		order by
			a.codigo_agricultor;
	end
$BODY$
  LANGUAGE plpgsql;

select * from f_listar_cultivo('1')

select 
		    codigo_agricultor, 
		    (apellido_paterno || ' ' || apellido_materno || ' ' || nombres) as nombre, 
		    direccion, 
		    usuario,
                    num_celular
		from 
		    agricultor 
		where 
		    lower(apellido_paterno || ' ' || apellido_materno || ' ' || nombres) like '%FARRO RUIZ EDDY%'


CREATE OR REPLACE FUNCTION public.f_listar_cultivo(
    IN p_codigo_agricultor integer
)
  RETURNS TABLE(codigo integer, nombre character varying, semilla character varying, agricultor character varying) AS
$BODY$
	
	begin
		return query
		select
			c.codigo_cultivo,
			c.nombre as cultivo,
			c.semilla,
			(a.apellido_paterno || ' ' || a.apellido_materno || ' ' || a.nombres) :: character varying as agricultor
		from
			cultivo c
			inner join agricultor a on ( c.codigo_agricultor = a.codigo_agricultor)
		where
			
			(case p_codigo_agricultor
				when '0' then
					'1'='1'
				else
					a.codigo_agricultor = p_codigo_agricultor
			end)
			
		order by
			c.nombre;
	end
$BODY$
  LANGUAGE plpgsql;

select 
		    nombres 
		from 
		    agricultor 
		where 
		    codigo_agricultor = 1


<?php

    //require_once 'sesion.validar.controlador.php';

    require_once '../negocio/Agricultor.clase.php';
    require_once '../util/funciones/Funciones.clase.php';
    
    try {
        $p_codigoAgricultor = $_POST["p_codigoAgricultor"];
        
	$obj = new Agricultor();
        $resultado = $obj->cargarListaDatos($p_codigoAgricultor);
	Funciones::imprimeJSON(200, "", $resultado);
	
    } catch (Exception $exc) {
	Funciones::imprimeJSON(500, $exc->getMessage(), "");
	
    }

select * from f_listar_agricultor2() 

CREATE OR REPLACE FUNCTION public.f_listar_agricultor2(
)
  RETURNS TABLE(nombre character varying) AS
$BODY$

	begin
		return query
		select
			(apellido_paterno || ' ' || apellido_materno || ' ' || nombres) :: character varying as nombre
		from
			agricultor  		
		order by
			codigo_agricultor;
	end
$BODY$
  LANGUAGE plpgsql;


SELECT 
                    usuario.codigo_usuario,
		    agricultor.usuario,
                    (agricultor.apellido_paterno||' '||agricultor.apellido_materno||' '||agricultor.nombres) as nombre_completo,
                    (case when usuario.estado = 'A' then 'ACTIVO' else 'INACTIVO' end) as estado
                  FROM 
                    public.usuario, 
                    public.agricultor
                  WHERE 
                    agricultor.codigo_agricultor = usuario.codigo_agricultor;

CREATE OR REPLACE FUNCTION public.f_listar_cultivo(
    IN p_codigo_departamento character,
    IN p_codigo_provincia character)
  RETURNS TABLE(codigo character, nombre character varying, departamento character varying, provincia character varying) AS
$BODY$
	
	
	begin
		return query
		select
			d.codigo_distrito,
			d.nombre,
			d.nombre as departamento,
			p.nombre as provincia
		from
			Distrito d 
			inner join provincia p on ( d.codigo_provincia = p.codigo_provincia)
			inner join departamento de on ( d.codigo_departamento = de.codigo_departamento)
		where
			(case p_codigo_departamento
				when '0' then 
					'1'='1'
				else
					de.codigo_departamento = p_codigo_departamento
			end)
			
			and --y
			
			(case p_codigo_provincia
				when '0' then 
					'1'='1'
				else
					p.codigo_provincia = p_codigo_provincia
			end)
			
			
			
		order by
			d.nombre;
	end
$BODY$
  LANGUAGE plpgsql

select d.*, p.codigo_provincia from distrito d inner join provincia p on (d.codigo_provincia = p.codigo_provincia) where codigo_distrito = '1'