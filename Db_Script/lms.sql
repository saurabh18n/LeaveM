USE [master]
GO
/****** Object:  Database [LMS]    Script Date: 07-04-2020 21:59:14 ******/
CREATE DATABASE [LMS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'LeaveMS', FILENAME = N'H:\DB\LMS.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'LeaveMS_log', FILENAME = N'H:\DB\LMS_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [LMS] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [LMS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [LMS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [LMS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [LMS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [LMS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [LMS] SET ARITHABORT OFF 
GO
ALTER DATABASE [LMS] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [LMS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [LMS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [LMS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [LMS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [LMS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [LMS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [LMS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [LMS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [LMS] SET  DISABLE_BROKER 
GO
ALTER DATABASE [LMS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [LMS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [LMS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [LMS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [LMS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [LMS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [LMS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [LMS] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [LMS] SET  MULTI_USER 
GO
ALTER DATABASE [LMS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [LMS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [LMS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [LMS] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [LMS] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [LMS] SET QUERY_STORE = OFF
GO
USE [LMS]
GO
/****** Object:  Table [dbo].[tab_employee]    Script Date: 07-04-2020 21:59:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tab_employee](
	[emp_id] [int] IDENTITY(1,1) NOT NULL,
	[emp_username] [nvarchar](50) NOT NULL,
	[emp_password] [nvarchar](128) NOT NULL,
	[emp_name] [nvarchar](100) NOT NULL,
	[emp_win] [nvarchar](20) NOT NULL,
	[emp_role] [tinyint] NOT NULL,
	[emp_lastLogin] [datetime] NOT NULL,
	[emp_loginfailcount] [tinyint] NOT NULL,
	[emp_depart] [nvarchar](6) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tab_takenBalanceIds]    Script Date: 07-04-2020 21:59:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tab_takenBalanceIds](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[vaca_id] [int] NOT NULL,
	[vac_id] [int] NOT NULL,
	[days] [tinyint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tab_vac_balance]    Script Date: 07-04-2020 21:59:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tab_vac_balance](
	[vac_id] [int] IDENTITY(1,1) NOT NULL,
	[vac_empid] [int] NOT NULL,
	[vac_createdate] [date] NOT NULL,
	[vac_expirydate] [date] NOT NULL,
	[vac_balance] [tinyint] NOT NULL,
	[vac_remark] [nvarchar](300) NULL,
	[vac_credit] [tinyint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tab_vac_taken]    Script Date: 07-04-2020 21:59:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tab_vac_taken](
	[vaca_id] [int] IDENTITY(1,1) NOT NULL,
	[vaca_empid] [int] NOT NULL,
	[vaca_start] [date] NOT NULL,
	[vaca_end] [date] NOT NULL,
	[vaca_days] [tinyint] NOT NULL,
	[vaca_remark] [nvarchar](300) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tab_variables]    Script Date: 07-04-2020 21:59:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tab_variables](
	[variable_id] [int] IDENTITY(1,1) NOT NULL,
	[variable_name] [nvarchar](20) NOT NULL,
	[value_date] [date] NULL,
	[value_int] [nchar](10) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tab_employee] ADD  CONSTRAINT [DF_tab_employee_emp_departmet]  DEFAULT ('') FOR [emp_depart]
GO
ALTER TABLE [dbo].[tab_vac_balance] ADD  CONSTRAINT [DF_tab_vac_balance_vac_credit]  DEFAULT ((0)) FOR [vac_credit]
GO
/****** Object:  StoredProcedure [dbo].[sp_addemployee]    Script Date: 07-04-2020 21:59:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_addemployee]
	-- Add the parameters for the stored procedure here
	@empwin nvarchar(10),
	@empname nvarchar(100),
	@empusername nvarchar (50),
	@empdepart nvarchar(6),
	@status tinyint output
	-- 0 success
	-- 1 duplicate WIN
	-- 2 Duplicate Username
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT @status = 4;
    -- Insert statements for procedure here
	IF EXISTS(SELECT NULL FROM tab_employee WHERE emp_win = @empwin)
		BEGIN
			SELECT @status = 1
		END
	ELSE IF EXISTS(SELECT NULL FROM tab_employee WHERE emp_username = @empusername)
		BEGIN
			SELECT @status = 2
		END
	ELSE
		BEGIN
			INSERT INTO tab_employee (emp_username,emp_password,emp_name,emp_win,emp_role,emp_lastLogin,emp_loginfailcount,emp_depart) VALUES
							(@empusername,@empwin,@empname,@empwin,1,SYSDATETIME(),0,@empdepart)
			SELECT @status = 0
		END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_changepassword]    Script Date: 07-04-2020 21:59:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_changepassword]
	-- Add the parameters for the stored procedure here
	@empid int,
	@oldpw nvarchar(128),
	@newpw nvarchar(128),
	@status tinyint output

	-- 0 success
	-- 1 password incorrect
	-- 2 error
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT @status = 2
    -- Insert statements for procedure here
	IF EXISTS(SELECT NULL FROM tab_employee WHERE emp_id= @empid AND  emp_password = @oldpw)
		BEGIN
			UPDATE tab_employee SET emp_password = @newpw WHERE emp_id = @empid
			SELECT @status = 0
		END
	ELSE
		BEGIN
			SELECT @status = 1
		END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_checkLogin]    Script Date: 07-04-2020 21:59:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<saurabh18n@gmail.com>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_checkLogin] 
	-- Add the parameters for the stored procedure here
	@username nvarchar(100),
	@password nvarchar(128),
	@empid INT output,
	@empRole tinyint output,
	@empfullname nvarchar(100) output,
	@loginsuccess bit output
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT NULL FROM tab_employee WHERE emp_username = @username AND emp_loginfailcount < 5)
		BEGIN
			IF EXISTS(SELECT NULL FROM tab_employee WHERE emp_username = @username AND emp_password = @password)
				BEGIN
					SELECT @empid = emp_id, @empfullname= emp_name,  @empRole = emp_role, @loginsuccess = 1 FROM tab_employee WHERE emp_username = @username
					UPDATE tab_employee SET emp_loginfailcount = 0, emp_lastLogin = SYSDATETIME() WHERE emp_username = @username
				END
			ELSE
				BEGIN
					UPDATE tab_employee SET emp_loginfailcount = emp_loginfailcount + 1, emp_lastLogin = SYSDATETIME() WHERE emp_username = @username
					SELECT @loginsuccess = 0
				END
		END
	ELSE
		BEGIN
		SELECT @loginsuccess = 0
		END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_delete_vacaonvacbalance]    Script Date: 07-04-2020 21:59:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_delete_vacaonvacbalance] 
	-- Add the parameters for the stored procedure here
	@vacid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	BEGIN TRY
		BEGIN TRAN deletevaca
		DELETE from tab_vac_taken WHERE vaca_id IN (SELECT vaca_id FROM tab_takenBalanceIds TB WHERE TB.vac_id = @vacid)
		DELETE FROM tab_takenBalanceIds WHERE vac_id = @vacid
		UPDATE tab_vac_balance SET vac_balance = vac_credit WHERE vac_id = @vacid
		COMMIT TRAN deletevaca
	END TRY
	BEGIN CATCH
		BEGIN
			ROLLBACK TRAN deletevaca 
		END
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[sp_employee_balance]    Script Date: 07-04-2020 21:59:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_employee_balance]
	-- Add the parameters for the stored procedure here
	@empid int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @date date = GETDATE(),
			@days int = (SELECT TOP 1 tab_variables.value_int FROM tab_variables WHERE variable_id = 1)

    -- Insert statements for procedure here
		SELECT
			   emp_win,
			   emp_name,
			   ISNULL(emp_taken,0) emp_taken,
			   ISNULL(emp_balance,0) emp_balance,
			   ISNULL(expiring_balance,0) expiring_balance FROM
		((((
		SELECT emp_id,emp_win,emp_name FROM tab_employee WHERE emp_id = @empid
		) a LEFT OUTER JOIN 
			(
			SELECT @empid empid,SUM(vac_balance) emp_balance FROM tab_vac_balance
			WHERE vac_expirydate >= @date AND vac_empid = @empid
			) b
		ON a.emp_id = b.empid) LEFT OUTER JOIN
		(
			SELECT @empid empid,SUM(vac_balance) expiring_balance FROM tab_vac_balance
			WHERE vac_expirydate >= @date AND 
			vac_expirydate BETWEEN @date AND DATEADD(DAY, @days,@date) 
			AND vac_empid = @empid
		)c on a.emp_id = c.empid) LEFT OUTER JOIN
			(
			SELECT @empid empid, SUM(vaca_days) emp_taken from tab_vac_taken
			WHERE  vaca_empid = @empid
			) d ON a.emp_id = d.empid)

			--Employee Basic details
			SELECT  vac_empid empid,vac_expirydate,vac_balance,
			CASE WHEN vac_expirydate BETWEEN @date AND DATEADD(DAY, @days,@date) THEN 'True' ELSE 'False' END Expiring
			FROM tab_vac_balance
			WHERE vac_expirydate >= @date			 
			AND vac_empid = @empid
			ORDER BY vac_expirydate

			--vacation taken history
			SELECT vaca_empid,vaca_start,vaca_end,vaca_days,DATEPART(YEAR,vaca_start) vaca_year,vaca_remark FROM tab_vac_taken
			WHERE vaca_empid = @empid
			ORDER by vaca_start
			
			-- Year wise employee accumulated granted and balance
			SELECT DATEPART(YEAR,vac_createdate) as vac_year,
			vac_credit,
			CASE WHEN vac_expirydate < GETDATE() THEN 0 ELSE vac_balance END as vac_balance,
			(vac_credit - vac_balance) as vac_taken,
			CASE WHEN vac_expirydate < GETDATE() THEN vac_balance ELSE 0 END as vac_expired
			FROM tab_vac_balance
			WHERE vac_empid = @empid

			--SELECT  year,
			--		ISNULL(accumulate,0)accumulate,
			--		ISNULL(available,0)available,
			--		ISNULL(taken,0)taken,
			--		expired
			--	FROM(
			--		SELECT DATEPART(YEAR,vac_createdate)year,SUM(vac_credit) accumulate, SUM(vac_balance)available,
			--		CASE WHEN vac_expirydate <= GETDATE() THEN 'True' ELSE 'False' END as expired
			--		FROM tab_vac_balance
			--		WHERE vac_empid = @empid
			--		GROUP BY DATEPART(YEAR,vac_createdate),CASE WHEN vac_expirydate <= GETDATE() THEN 'True' ELSE 'False' END) a
			--	LEFT OUTER JOIN (		
			--		SELECT DATEPART(YEAR,vaca_start) byear, SUM(vaca_days) taken FROM tab_vac_taken
			--		WHERE vaca_empid = @empid
			--		GROUP BY DATEPART(YEAR,vaca_start)) b ON a.year = b.byear 

END
GO
/****** Object:  StoredProcedure [dbo].[sp_get_emp_balance_admin]    Script Date: 07-04-2020 21:59:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_emp_balance_admin]
	-- Add the parameters for the stored procedure here
	@empid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Leave Credit balance
		SELECT vac_id, vac_createdate,vac_credit,vac_balance,ISNULL(vac_remark,'')vac_remark FROM tab_vac_balance 
		WHERE vac_empid = @empid
		ORDER BY vac_createdate DESC
	-- Lave Taken Detaild
		SELECT vaca_id, vaca_start,vaca_end,vaca_days,ISNULL(vaca_remark,'')vaca_remark FROM tab_vac_taken
		WHERE vaca_empid = @empid
		ORDER BY vaca_start DESC
	-- Employee Details
		SELECT emp_name,
		emp_win,
		CASE WHEN emp_loginfailcount > 4 THEN CONVERT(BIT,1) ELSE CONVERT(BIT,0) END locked,
		emp_username,
		emp_lastLogin
		FROM tab_employee WHERE emp_id = @empid
	-- Employee Balance
		SELECT vac_expirydate,vac_balance FROM tab_vac_balance 
		WHERE vac_empid = @empid AND
		vac_balance > 0
		ORDER BY vac_expirydate

END
GO
/****** Object:  StoredProcedure [dbo].[sp_leave_add]    Script Date: 07-04-2020 21:59:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_leave_add] 
	-- Add the parameters for the stored procedure here
	@empid int,
	@craditdate date,
	@days tinyint,
	@remarks nvarchar(100)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO tab_vac_balance 
	(vac_empid,vac_createdate,vac_expirydate,vac_credit,vac_balance,vac_remark) Values
	(@empid,@craditdate,DATEADD(DAY,558,@craditdate),@days,@days,@remarks)

END
GO
/****** Object:  StoredProcedure [dbo].[sp_leave_delete]    Script Date: 07-04-2020 21:59:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_leave_delete] 
	-- Add the parameters for the stored procedure here
	@vacid int,
	@status nvarchar(100) output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF NOT EXISTS(SELECT NULL FROM tab_takenBalanceIds WHERE vac_id = @vacid)
		BEGIN			
			DELETE FROM tab_vac_balance WHERE vac_id = @vacid
			SELECT @status = 'Deleted Successfully'
		END
	ELSE
		BEGIN
			SELECT @status = 'Taken Leave Present on this'			
		END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_leave_delete_check]    Script Date: 07-04-2020 21:59:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_leave_delete_check] 
	-- Add the parameters for the stored procedure here
	@vacid int,
	@takenvac tinyint output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT NULL FROM tab_takenBalanceIds WHERE vac_id = @vacid)
		BEGIN
			SELECT @takenvac = 1
			SELECT vaca_start,vaca_end,vaca_days FROM tab_vac_taken WHERE vaca_id  IN (SELECT TB.vaca_id FROM tab_takenBalanceIds TB WHERE vac_id = @vacid)
		END
	ELSE
		BEGIN
			SELECT @takenvac = 0
		END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_leave_update]    Script Date: 07-04-2020 21:59:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_leave_update] 
	-- Add the parameters for the stored procedure here
	@vacid int,
	@craditdate date,
	@days tinyint,
	@remarks nvarchar(100)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE tab_vac_balance
		SET 
		vac_balance = @days - (vac_credit - vac_balance),
		vac_createdate = @craditdate,
		vac_expirydate = DATEADD(DAY,558,@craditdate),
		vac_remark = CASE WHEN @remarks = '' THEN vac_remark ELSE CONCAT(vac_remark , N', ',  @remarks) END,
		vac_credit = @days
	WHERE vac_id = @vacid

END
GO
/****** Object:  StoredProcedure [dbo].[sp_resetuserpassword]    Script Date: 07-04-2020 21:59:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_resetuserpassword] 
	-- Add the parameters for the stored procedure here
	@empid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE tab_employee SET emp_password = emp_win WHERE emp_id = @empid
END
GO
/****** Object:  StoredProcedure [dbo].[sp_search_employee]    Script Date: 07-04-2020 21:59:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_search_employee] 
	-- Add the parameters for the stored procedure here
	@searchterm nvarchar (50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TOP 20 emp_id,emp_win,emp_name from tab_employee
	WHERE emp_name LIKE '%' + @searchterm + '%' OR emp_win LIKE '%' + @searchterm + '%'
END
GO
/****** Object:  StoredProcedure [dbo].[sp_taken_add]    Script Date: 07-04-2020 21:59:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_taken_add]
	-- Add the parameters for the stored procedure here
	@empid int,
	@datefrom date,
	@dateto date,
	@leavedays smallint,
	@remark nvarchar(300),
	@status bit output,
	@satatustext nvarchar(300) output

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--getting balance of employee
	DECLARE @leavetakenid int,
			@leaveBalance smallint
	SELECT @leaveBalance = ISNULL(SUM(vac_balance),0) FROM tab_vac_balance
				WHERE vac_empid = @empid AND vac_expirydate >= @dateto
	SELECT @leaveBalance;
	BEGIN TRY
		BEGIN TRAN addleave
		IF(@leavedays > @leaveBalance)
			BEGIN 
				SELECT @satatustext = 'Leave Balance is not available',@status = 0
			END
		ELSE
			BEGIN
			
			INSERT INTO tab_vac_taken (vaca_empid,vaca_start,vaca_end,vaca_days,vaca_remark) VALUES(@empid,@datefrom,@dateto,@leavedays,@remark)
			SELECT @leavetakenid = SCOPE_IDENTITY();
			SELECT @satatustext = '';
				DECLARE @curruntdate date = @datefrom,
						@vacid int,
						@expdate date,
						@rowbalance as tinyint,
						@diff smallint
				DECLARE cursorleave CURSOR
				FOR
				SELECT  vac_id,vac_expirydate,vac_balance FROM tab_vac_balance
						WHERE vac_expirydate >= @datefrom	 -- Leave is not Expired
						AND vac_empid = @empid				 -- Picking Leave for particuler employee
						AND vac_balance > 0                  -- Select Only if Balance is available in Row.
						ORDER BY vac_expirydate				 -- Picking  Oldest leave first
				OPEN cursorleave
				--Fatching values from cursor
				FETCH NEXT FROM cursorleave INTO
					@vacid, @expdate, @rowbalance

					WHILE (@@FETCH_STATUS = 0 AND @leavedays > 0)
						BEGIN						
							IF(@leavedays <= @rowbalance)
							--Leave will be adjusted in one entry
								BEGIN
									IF(@dateto <= @expdate)
										BEGIN
											UPDATE tab_vac_balance SET vac_balance = vac_balance - @leavedays WHERE vac_id = @vacid	
											INSERT INTO tab_takenBalanceIds (vaca_id,vac_id,days) VALUES
														(@leavetakenid,@vacid,@leavedays)
											SELECT @satatustext += (CONVERT(NVARCHAR,@leavedays)  +' Days against balance expiring on ' + CONVERT(NVARCHAR,@expdate,110) + '\n'),@status = 1
											SELECT @leavedays = 0
										END
									ELSE
									--Leave can not be adjusted in 1 row but some can be
										BEGIN
											SELECT @diff = DATEDIFF(DAY,@expdate,@dateto) -- days which are falling past expirydate of this balance
											UPDATE tab_vac_balance SET vac_balance = vac_balance - (@leavedays-@diff) WHERE vac_id = @vacid
											INSERT INTO tab_takenBalanceIds (vaca_id,vac_id,days) VALUES
														(@leavetakenid,@vacid,(@leavedays-@diff))
											SELECT @satatustext += (CONVERT(nvarchar,@leavedays-@diff) + ' Days against balance expiring on ' + CONVERT(NVARCHAR,@expdate,110) + '\n'),@status = 1
											SELECT @leavedays = @diff
											FETCH NEXT FROM cursorleave INTO
											@vacid, @expdate, @rowbalance									
										END
								END
							ELSE -- Now ask days are greater then row balance
								BEGIN
									IF(@dateto <= @expdate)
										BEGIN
											UPDATE tab_vac_balance SET vac_balance = vac_balance - @rowbalance WHERE  vac_id = @vacid	
											SELECT @satatustext += (CONVERT(NVARCHAR, @rowbalance) +  ' Days against balance expiring on ' + CONVERT(NVARCHAR,@expdate,110) + '\n'),@status = 1
											SELECT @leavedays = @leavedays - @rowbalance
											INSERT INTO tab_takenBalanceIds (vaca_id,vac_id,days) VALUES
														(@leavetakenid,@vacid,@rowbalance)
											FETCH NEXT FROM cursorleave INTO
											@vacid, @expdate, @rowbalance
										END
									ELSE
									--Leave can not be adjusted in 1 row but some can be
										BEGIN
											SELECT @diff  = DATEDIFF(DAY,@expdate,@dateto) -- days which are falling past expirydate of this balance
											UPDATE tab_vac_balance SET vac_balance = vac_balance - 
											CASE WHEN (@leavedays-@diff) <= @rowbalance THEN (@leavedays-@diff) ELSE @rowbalance END WHERE vac_id = @vacid
											INSERT INTO tab_takenBalanceIds (vaca_id,vac_id,days) VALUES
														(@leavetakenid,@vacid,(CASE WHEN (@leavedays-@diff) <= @rowbalance THEN (@leavedays-@diff) 
														ELSE @rowbalance END))
											SELECT @satatustext += (CONVERT(NVARCHAR,CASE WHEN (@leavedays-@diff) <= @rowbalance THEN (@leavedays-@diff) ELSE @rowbalance END)+ ' Days against balance expiring on ' + CONVERT(NVARCHAR,@expdate,110) + '\n'),@status = 1
											SELECT @leavedays = CASE WHEN (@leavedays-@diff) <= @rowbalance THEN (@diff) ELSE @leavedays - @rowbalance END
																						
											FETCH NEXT FROM cursorleave INTO
											@vacid, @expdate, @rowbalance				
										END
								END
						END
			
				CLOSE cursorleave;  -- Closing Cursor
				DEALLOCATE cursorleave;
				END
				UPDATE tab_vac_taken SET vaca_remark +=  N' ' + REPLACE(@satatustext,'\n', ', ') WHERE vaca_id = @leavetakenid
				COMMIT TRAN addleave
	END TRY
	BEGIN CATCH
		BEGIN
			ROLLBACK TRAN addleave
			SELECT @status = 0,@satatustext ='Error' +  ERROR_MESSAGE()		
		END
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[sp_taken_delete]    Script Date: 07-04-2020 21:59:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_taken_delete] 
	-- Add the parameters for the stored procedure here
	@vaca int,
	@status bit output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Update balance to accumulate row
	BEGIN TRY
		BEGIN TRAN delTaken		
					UPDATE tab_vac_balance SET vac_balance = vac_balance + TI.days
					FROM tab_vac_balance VB INNER JOIN tab_takenBalanceIds TI ON VB.vac_id = TI.vac_id
					WHERE TI.vaca_id = @vaca	
					-- delete entries from tab_takenBalanceIds
					DELETE FROM tab_takenBalanceIds WHERE vaca_id = @vaca
					-- delete taken row
					DELETE FROM tab_vac_taken WHERE vaca_id = @vaca
					SELECT @status = 1
					COMMIT TRAN delTaken 
	END TRY
	BEGIN CATCH
		SELECT @status = 0
		ROLLBACK TRAN delTaken
	END CATCH
	
END
GO
/****** Object:  StoredProcedure [dbo].[sp_taken_update]    Script Date: 07-04-2020 21:59:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_taken_update] 
	-- Add the parameters for the stored procedure here
	@vaca int,
	@empid int,
	@datefrom date,
	@dateto date,
	@leavedays smallint,
	@remark nvarchar(100),
	@status bit output,
	@satatustext nvarchar(300) output

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @newremark nvarchar(300) =(SELECT CONCAT((SELECT ISNULL(vaca_remark,'') FROM tab_vac_taken WHERE vaca_id = @vaca),N', ', @remark))

	BEGIN TRY
		BEGIN TRAN updatetaken
		EXEC [dbo].[sp_taken_delete]
			@vaca = @vaca,
			@status = @status OUTPUT
		EXEC [dbo].[sp_taken_add]
			@empid = @empid,
			@datefrom = @datefrom,
			@dateto = @dateto,
			@leavedays = @leavedays,
			@remark = @newremark,
			@status = @status OUTPUT,
			@satatustext = @satatustext OUTPUT
		COMMIT TRAN updatetaken
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN updatetaken
		SELECT @satatustext = ERROR_MESSAGE()
	END CATCH	
END
GO
/****** Object:  StoredProcedure [dbo].[sp_unlockuser]    Script Date: 07-04-2020 21:59:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_unlockuser]
	-- Add the parameters for the stored procedure here
	@empid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE tab_employee SET emp_loginfailcount = 0 WHERE emp_id	= @empid
END
GO
USE [master]
GO
ALTER DATABASE [LMS] SET  READ_WRITE 
GO
