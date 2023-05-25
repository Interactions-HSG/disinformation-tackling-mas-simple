// The organization metadata
org_name("disinformation_tackling_org").
group_name("disinformation_tackling_team").
sch_name(content_evaluation_scheme).

// The list of articles in progress and evaluated
articles_in_progress([]).
articles_evaluated([]).

scheme_count(0).
/* Initial goals */

!start.

/* Plans */
@start_plan
+!start : org_name(OrgName)
    <- .print("I am the administrator of the fact checking project.");
        makeArtifact(OrgName, "ora4mas.nopl.OrgBoard", ["src/org/org.xml"], OrgArtId);
        focus(OrgArtId);

        //simulate requests to admin from the front-end
        +article("Article1", general_impression, annotator_agent_1);
        .wait(10000);
        +article("Article1", general_impression, annotator_agent_2);
        .wait(10000);
        +article("Article2", general_impression, annotator_agent_1);
        .wait(10000);
        +article("Article1", article_subject, annotator_agent_1).

@handle_new_request_for_article_evaluation             
+article(ArticleId, ProcessId, AgentName): 
    articles_evaluated(ArticlesEvaluated)
    & not .member(ArticleId,ArticlesEvaluated) <- 
    
    // manage article related lists
    !manage_article_in_progress(ArticleId);
    .print(ArticleId,", " ,ProcessId);

    // manage task allocation
    !!manage_article_evaluation(ArticleId, ProcessId, AgentName).

@handle_artifact_evaluation
+!manage_article_evaluation(ArticleId, ProcessId, AgentName) : true <-
    // (optionally create and) inform annotator agent about its relevant evaluation
    .send(AgentName, tell, article_evaluation("SurveyAnswers", ProcessId, ArticleId));

    // create new disinformation tackling team for the article if it does not exist
    ?disinformation_tackling_team(ArticleId, GroupName);    
    
    // inform the relevant annotator agent 
    .send(AgentName, tell, disinformation_tackling_team(ArticleId, GroupName));

    .wait(formationStatus(ok)[artifact_id(GrArtId)]);

    // create new disinformation tackling scheme for the process if it does not exist
    ?disinformation_tackling_scheme(SchemeName, ArticleId, GroupName);

    // inform the relevant annotator agent
    .send(AgentName, tell, disinformation_tackling_scheme(SchemeName, ArticleId, ProcessId, GroupName)).

@handle_article_in_progress
+!manage_article_in_progress(ArticleId) : 
    articles_in_progress(ArticlesInProgress)
    & not .member(ArticleId, ArticlesInProgress) <-
    // simply updates the list of articles in progress
    .concat(ArticlesInProgress,[ArticleId], NewArticlesInProgress);
    -+articles_in_progress(NewArticlesInProgress).

@handle_article_in_progress_known_article
+!manage_article_in_progress(ArticleId) : true .

@create_disinformation_tackling_team
+?disinformation_tackling_team(ArticleId, GroupName) : group_name(GroupType)  <-
    !get_group_name(GroupType, ArticleId, GroupName);
    createGroup(GroupName, GroupType, GrArtId);
    +disinformation_tackling_team(ArticleId, GroupName);
    focus(GrArtId);
    adoptRole(admin)[artifact_id(GrArtId)];
    !inspect(GrArtId);
    
    // inform the aggregator agent since it is always needed in such teams
    .send(aggregator_agent, tell, disinformation_tackling_team(ArticleId, GroupName)).

@create_disinformation_tackling_scheme
+?disinformation_tackling_scheme(SchemeName, ArticleId, GroupName): 
    scheme_count(SchemeCount) 
    & group_name(GroupType)
    & sch_name(SchemeType) <-
    
    // create scheme
    !get_scheme_name(SchemeType, SchemeCount, SchemeName);
    createScheme(SchemeName, SchemeType, SchArtId);
    addScheme(SchemeName)[artifact_id(GrArtId)];
    focus(SchArtId)[wid(WspId)];
    !inspect(SchArtId);
    -+scheme_count(SchemeCount + 1);

    // inform the relevant annotator agent
    +disinformation_tackling_scheme(SchemeName, ArticleId, GroupName).

@get_group_name
+!get_group_name(GroupType, ArticleId, GroupName) : true <-
    .concat(GroupType, ArticleId, GroupName).

@get_scheme_name
+!get_scheme_name(SchemeType, SchemeCount, SchemeName) : true <-
    .concat("_", (SchemeCount + 1), Postfix);
    .concat(SchemeType, Postfix, SchemeName).

@inspect_org_artifacts_plan
+!inspect(OrganizationalArtifactId) : true <-
  // performs an action that launches a console for observing the organizational artifact
  // the action is offered as an operation by the superclass OrgArt (https://moise.sourceforge.net/doc/api/ora4mas/nopl/OrgArt.html)
  debug(inspector_gui(on))[artifact_id(OrganizationalArtifactId)].

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
