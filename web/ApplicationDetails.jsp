<%
            /**************************************************************************
            Copyright (c) 2011:
            Istituto Nazionale di Fisica Nucleare (INFN), Italy
            Consorzio COMETA (COMETA), Italy

            See http://www.infn.it and and http://www.consorzio-cometa.it for details on the
            copyright holders.

            Licensed under the Apache License, Version 2.0 (the "License");
            you may not use this file except in compliance with the License.
            You may obtain a copy of the License at

            http://www.apache.org/licenses/LICENSE-2.0

            Unless required by applicable law or agreed to in writing, software
            distributed under the License is distributed on an "AS IS" BASIS,
            WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
            See the License for the specific language governing permissions and
            limitations under the License.
             ****************************************************************************/
            /**
             *
             *
             * @author m.fargetta - s.monforte - r.ricceri
             */

%>
<%@page import="com.liferay.portal.util.PortalUtil"%>
<%@page import="com.liferay.portal.model.Company"%>
<%@page trimDirectiveWhitespaces="true"%>
<%@page import="java.sql.Blob" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="portlet" uri="http://java.sun.com/portlet_2_0" %>
<portlet:defineObjects/>
<%            pageContext.setAttribute("qMap", request.getAttribute("qMap"));
            Company company = PortalUtil.getCompany(request);
            String gateway = company.getName();
            System.out.println(request.getParameter("runUrl"));
%>
<c:set var="runUrl" value="<%= request.getParameter("runUrl")%>" />

<div class="demo">

    <div id="tabs">
        <ul>
            <li><a href="#tabs-1">General info</a></li>
            <li><a href="#tabs-2">Technical info</a></li>
            <li><a href="#tabs-3">Team of collaborators</a></li>
            <li><a href="#tabs-4">References</a></li>

        </ul>
        <div id="tabs-1">
            <div style="float:left;">

            </div>
            <div>
                <div style="float:left; padding-right: 15px;">
                    <img alt="${qMap.acronym}"  src="/ApplicationRegistryFull/ImageRetrive?AppID=${qMap.applicationID}" width="200px" onerror="this.src='/ApplicationRegistryFull/image/settings.png';this.width='48';"/>
                </div>
                <div><p><b>Acronym: </b>${qMap.acronym}</p>
                    <p><b>Name: </b>${qMap.appName} </p>
                    <p><b>Project Application: </b>${qMap.project}</p>
                    <p><b>Region: </b>${qMap.region}</p>
                    <b>Abstract: </b><div align="justify" style="font-size:10px;">${qMap.abstract}</div>
                    <c:if test="${! empty fn:substringAfter(qMap.url,'://')}">
                        <p><img alt="URL"  src="/ApplicationRegistryFull/image/wwwicon.gif"/><a href="${qMap.url}">${qMap.url}</a></p>
                        </c:if>
                    <div>
                        <sql:query var="queryRun" dataSource="jdbc/ApplicationRegistry">
                            Select run_url, gateway from application_per_runpage where applicationID=  ${qMap.applicationID} AND gateway= "<%= gateway%>"
                        </sql:query>
                        <c:choose>
                            <c:when test="${(queryRun.rowCount !=0 )}">
                                <c:forEach var="run" items="${queryRun.rows}">
                                    <b>Run Page:</b>
                                    <a href="${run.run_url}/run-${fn:toLowerCase(qMap.acronym)}"><img src="/ApplicationRegistryFull/image/${fn:replace(run.gateway," ","")}.png" /></a>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <sql:query var="queryRunAll" dataSource="jdbc/ApplicationRegistry">
                                    Select run_url, gateway from application_per_runpage where applicationID=  ${qMap.applicationID}
                                </sql:query>
                                <c:if test="${(queryRunAll.rowCount !=0 )}">
                                    <b>Run Page:</b>
                                    <c:forEach var="all" items="${queryRunAll.rows}">
                                        <a href="${all.run_url}/${fn:toLowerCase(qMap.acronym)}"><img src="/ApplicationRegistryFull/image/${all.gateway}.png" /></a>
                                        </c:forEach>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                    </div>
                    
                </div>

                <div style="border:1px #9d9d9d dotted;">
                    <c:if test="${!empty qMap.multimedia2}">
                        <a href="${qMap.multimedia2}" class="preview"><img src="${qMap.multimedia2}" alt="image" width="72" height="72"/></a>
                        </c:if>
                        <c:if test="${!empty qMap.multimedia4}">
                        <a href="${qMap.multimedia4}" class="preview"><img src="${qMap.multimedia4}" alt="image" width="72" height="72"/></a>
                        </c:if>
                </div>

            </div>
        </div>
        <div id="tabs-2">
            <p><b>Status: </b><span class="${qMap.status}">${qMap.status}</span></p>
            <p><b>Infrastructure: </b>${qMap.infrastructure}</p>
            <p><b>Domain: </b>${qMap.domain}</p>
            <p><b>SubDomain: </b>${qMap.subdomain}</p>
            <p><b>Virtual Organization: </b>${qMap.vo}</p>
            <p><b>Middleware: </b>${qMap.middleware}</p>
            <p><b>Compiler: </b>${qMap.compiler}</p>
        </div>
        <div id="tabs-3">
            <sql:query var="researcher" dataSource="jdbc/ApplicationRegistry">
                 SELECT DISTINCT researcherID AS ID, firstname, lastname, institution, institutionID,institutionURL, country.ISOcode AS ISOcode,country.countryID AS countryID, info AS email
                FROM application_per_institution
                LEFT JOIN researcher USING (researcherID)
                LEFT JOIN team USING(researcherID)
                LEFT JOIN contact using (researcherID)
                left join institution using (institutionID)
		LEFT JOIN country USING(countryID)
                WHERE typecontactID='7' and team.applicationID=${qMap.applicationID}

            </sql:query>
            <table>
                <c:forEach var="researcher" items="${researcher.rows}">

                    <tr>
                        <td>
                            <img alt="image-staff"  src="/ApplicationRegistryFull/image/staff_icon.png">
                        </td>
                        <td  style="border-left:#9d9d9d 1px dotted; padding: 10px; font-size: 12px;">
                            <table>
                                <tr><td><b>Name:</b></td> <td><c:out value="${researcher.firstname}"/>  <b><c:out value="${researcher.lastname}"/></b></td></tr>
                                <tr><td><b>Institute:</b></td><td><a href="<c:out value="${researcher.institutionURL}"/>" target="_blank"><c:out value="${researcher.institution}"/></a></td></tr>
                                <tr><td><b>Country:</b></td><td><img alt="image-<c:out value="${researcher.ISOcode}"/>"  width="16" height="16" src="/ApplicationRegistryFull/flags/<c:out value="${researcher.ISOcode}"/>.png" align="center"></td></tr>
                                <tr><td><b>Contact:</b> </td><td>email <c:out value="${researcher.email}"/></td></tr>

                            </table>
                        </td>
                    </tr>
                </c:forEach>

            </table>
        </div>
        <div id="tabs-4">
            <sql:query var="contributions" dataSource="jdbc/ApplicationRegistry">
                SELECT distinct (contributionID),description as type, doctitle, docyear, docurl, isbn
                FROM contribution
                LEFT JOIN application_per_region USING (applicationID)
                LEFT JOIN typeref USING (typerefID)
                WHERE application_per_region.applicationID=contribution.applicationID and applicationID=${qMap.applicationID}
            </sql:query>

            <table id="contribution" class="display" width="100%">
                <thead>
                    <tr>
                        <th>type</th>
                        <th>title</th>
                        <th>year</th>
                        <th>isbn</th>
                    </tr>
                </thead>
                <tbody>

                    <c:forEach var="contribution" items="${contributions.rows}">
                        <tr>
                            <td> <c:out value="${contribution.type}"/></td>
                            <td> <a href="<c:out value="${contribution.docurl}"/>" target="_blank"><c:out value="${contribution.doctitle}"/></a></td>
                            <td> <c:out value="${contribution.docyear}"/></td>
                            <td> <c:out value="${contribution.isbn}"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>


        </div>

    </div>

</div>
