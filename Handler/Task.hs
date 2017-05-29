module Handler.Task where
import Import
import qualified Data.UUID as UUID
import Task.EventType

postTaskR :: Handler Value
postTaskR = do
  --t <- (parseJsonBody :: Handler (Result Value) )
  t <- (requireJsonBody :: Handler Task)
  {-
  returnJson Task {
    taskState = (1::Int), 
    taskTask_id =  (UUID.nil), 
    taskEvent_id = (UUID.nil),
    taskEvent_type = Create,
    taskTask_name = ("test"::Text),
    taskShort_description =("test"::Text), 
    taskDescription = ("test"::Text),
    taskJustification = ("test"::Text)
    }

  val <- case t of
    Success thing -> returnJson thing
    Error es -> returnJson es
  -}
 
  --let t' = t {taskShort_description = ("new thingy"::Text)} 
  returnJson t



