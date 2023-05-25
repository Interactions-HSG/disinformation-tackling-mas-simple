// The organization metadata
org_name("disinformation_tackling_org").
group_name("disinformation_tackling_team").
sch_name("disinformation_tackling_scheme").



/* Initial goals */

/* Plans */

+disinformation_tackling_team(ArticleId, GroupName) : org_name(OrgName) <-
    ?focusing(_,OrgName,"ora4mas.nopl.OrgBoard",_,_,_);
    .print("Joining new group: ", GroupName);
    adoptRole(annotator).

+disinformation_tackling_scheme(SchemeName, ArticleId, ProcessId, GroupName): 
    article_evaluation(SurveyAnswers, ProcessId, ArticleId) <-
    .print("Received notification of new mission in scheme ", SchemeName);
    .wait(3000);
    lookupArtifact(SchemeName, SchArtId);
	focus(SchArtId);
    .concat(ProcessId, "_mission", MissionId);
	commitMission(MissionId)[artifact_id(SchArtId)].

+?focusing(_,OrgName,"ora4mas.nopl.OrgBoard",_,_,_) : true <-
    lookupArtifact(OrgName, OrgArtId);
    focus(OrgArtId).

+!capture_general_article_impression: true <-
    .print("Capturing general article impression").

+!capture_article_subject: true <-
    .print("Capture article subject").

+obligation(Ag,Norm,done(Scheme,Goal,Ag),Deadline): .my_name(Ag) <-
    .println("I am obliged to achieve goal ",Goal, " on ", Scheme);
    !Goal[scheme(Scheme)];
    lookupArtifact(Scheme, SchemeArtId);
    goalAchieved(Goal)[artifact_id(SchemeArtId)].